#!/bin/bash

###############################################################################
# ncd - simple command line app combining cd with $CDPATH and more.
#
# Uses two configuration files:
#   ~/.config/ncd/paths
#   ~/.config/ncd/excludes
#
# Example config files (one path per line)
#
#   ~/.config/ncd/paths:
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
    local paths=()
    local xx ix
    local findopt=""

    [ "$follow_symlinks" = "yes" ] && findopt="-L"

    [ -d "$ncddir" ] || mkdir -p "$ncddir"

    # Now try match to predefined paths.
    if [ -r "$pathsconf" ] ; then
        if [ $(/usr/bin/stat -c %s "$pathsconf") -gt 0 ] ; then
            readarray -t paths <<< $(/usr/bin/cat "$pathsconf" | NcdRemoveComments | /usr/bin/sed -e "s|^\$HOME|$HOME|" -e "s|^~|$HOME|")
        fi
    fi

    if [ -n "$CDPATH" ] ; then
        for xx in $(echo "$CDPATH" | tr ':' ' ') ; do
            paths+=("$xx")
        done
    fi
    for ((ix=0; ix < ${#paths[@]}; ix++)) ; do
        xx="${paths[$ix]}"
        [ "${xx: -1}" = "/" ] || paths[$ix]+="/"   # allow symlinks
    done

    [ -n "$paths" ] || return 1

    # search predefined
    for xx in "${paths[@]}" ; do
        treedata+="$(/usr/bin/find $findopt "$xx" -type d)"
    done

    if [ -r "$excludes" ] ; then
        # filter excluded paths
        for xx in $(cat $excludes | NcdRemoveComments) ; do
            treedata="$(echo "$treedata" | /usr/bin/grep -v "$xx")"
        done
    fi

    # filter duplicate paths
    treedata="$(echo "$treedata" | /usr/bin/sort | /usr/bin/uniq)"

    # find a match (or many matches)
    readarray -t newdir <<< "$(echo "$treedata" | /usr/bin/grep -P "/$arg"[^/]*$)"

    if [ "${#newdir[@]}" -gt 1 ] ; then
        newdir="$(NcdSelectFromList "${newdir[@]}")"
        [ $? -eq 0 ] || return 1
    fi
}

NcdOptions() {
    local conf=$HOME/.config/ncd/ncd.conf
    local NCD_PATHS_OPTS
    local NCD_EXCLUDES_OPTS
    local xx

    source $conf || return 1

    for xx in "${NCD_PATHS_OPTS[@]}" ; do
        case "$xx" in
            -L) follow_symlinks=yes ;;
            *)  echo "Error: unsupported parameter '$xx' in NCD_PATHS_OPTS." >&2 ; exit 1 ;;
        esac
    done

    for xx in "${NCD_EXCLUDES_OPTS[@]}" ; do
        case "$xx" in
            *)  echo "Error: unsupported parameter '$xx' in NCD_EXCLUDES_OPTS." >&2 ; exit 1 ;;
        esac
    done
}

ncd() {
    local arg="$1"
    local follow_symlinks=no                # safer default not to follow symlinks

    NcdOptions

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
