#!/bin/bash

###############################################################################
# ncd - simple command line app like Norton CD in the 80's.
#
# Requires two configuration files:
#   ~/.config/ncd/paths
#   ~/.config/ncd/excludes
#
# Example config files (one path per line)
#
#   ~/.config/ncd/paths:  (note the trailing '/')
#      ~/Documents/
#      ~/MyData/
#
#   ~/.config/ncd/excludes:  (note the leading '/', and trailing '/' or '$')
#
#      /.git/
#      /.git$
#      /Documents/unimportant/
#      /Documents/unimportant$
#
#   Markings above:
#      '/' marks the directory separator
#      '$' marks the leaf subdirectory
#
###############################################################################

NcdSelectFromList() {
    local newdirs=("$@")
    local ix reply dir

    while true ; do
        for ((ix=0; ix < ${#newdirs[@]}; ix++)) ; do
            dir="${newdirs[$ix]}"
            case "$dir" in
                $HOME/*) dir="~${dir#$HOME}" ;;
            esac
            printf "%2d   %s\n" "$((ix+1))" "$dir" >&2
        done
        read -p "Select number or Q: " reply >&2
        case "$reply" in
            [qQ]*) echo "[quit]" ; return 1 ;;
        esac
        [ -z "$(echo "$reply" | tr -d '0-9')" ] || continue
        if [ "$reply" -ge 1 ] && [ "$reply" -le ${#newdirs[@]} ] ; then
            echo "${newdirs[$((reply-1))]}"
            return 0
        fi
    done
}

NcdRemoveComments() { /usr/bin/sed '/^[ ]*#.*$/d' ; }

NcdCandidates() {
    local ncddir=$HOME/.config/ncd
    local pathsconf=$ncddir/paths             # must have trailing /
    local excludes=$ncddir/excludes           # must have trailing / or $
    local treedata=""
    local paths
    local xx

    [ -d "$ncddir" ]  || mkdir -p "$ncddir"
    [ -r $pathsconf ] || touch $pathsconf
    [ -r $excludes ]  || touch $excludes

    # Now try match to predefined paths.
    readarray -t paths <<< $(/usr/bin/cat "$pathsconf" | NcdRemoveComments | /usr/bin/sed -e "s|^\$HOME|$HOME|" -e "s|^~|$HOME|")

    [ -n "$paths" ] || return 1

    # search predefined
    for xx in "${paths[@]}" ; do
        treedata+="$(/usr/bin/find "$xx" -type d)"
    done

    # filter excluded paths
    for xx in $(cat $excludes | NcdRemoveComments) ; do
        treedata="$(echo "$treedata" | /usr/bin/grep -v "$xx")"
    done

    # filter duplicate paths
    treedata="$(echo "$treedata" | /usr/bin/sort | /usr/bin/uniq)"

    # find a match (or many matches)
    readarray -t newdir <<< "$(echo "$treedata" | /usr/bin/grep -P "/$arg"[^/]*$)"

    if [ "${#newdir[@]}" -gt 1 ] ; then
        newdir="$(NcdSelectFromList "${newdir[@]}")"
        [ $? -eq 0 ] || return 1
    fi
}

ncd() {
    local arg="$1"

    #######################################
    # excludes:
    #   - a definition per line
    #   - grep syntax !?
    #   - basic definitions usually have leading and trailing /
    #   - trailing / can also be trailing $
    # paths:
    #   - a definition per line
    #   - 'find' syntax for the starting folder
    #######################################
    local xx yy=() zz

    # simple cases: use cd
    case "$arg" in
        . | */. | .. | */.. | -)
            cd "$arg" >/dev/null ; return ;;
        "")
            cd ; return ;;
    esac

    # Try a match using the $arg directly.

    readarray -t zz <<< "$(/usr/bin/ls -d1 "$arg"* 2>/dev/null)"
    if [ -n "$zz" ] ; then
        for xx in "${zz[@]}" ; do
            [ -d "$xx" ] && yy+=("$xx")
        done
        if [ -n "$yy" ] ; then
            if [ "${#yy[@]}" -eq 1 ] ; then
                cd "$yy"
                return
            else
                yy="$(NcdSelectFromList "${yy[@]}")"
                [ $? -eq 0 ] || return
                cd "$yy"
                return
            fi
        fi
    fi

    # Use predefined paths.

    local newdir
    NcdCandidates || return 1
    
    if [ -d "$newdir" ] ; then
        cd "$newdir"
    else
        echo "Sorry, folder starting with '$arg' not found." >&2
    fi
}
