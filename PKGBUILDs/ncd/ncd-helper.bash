#!/bin/bash

###############################################################################
#
# Author: manuel (see https://forum.endeavouros.com)
#
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
#      /\.git/
#      /\.git$
#      /Documents/unimportant/
#      /Documents/unimportant$
#
#   Markings above:
#      '/' marks the directory separator
#      '$' marks the leaf subdirectory
#
###############################################################################

NcdError() {
    echo "Error: $1" >&2
}

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

        read -p "Select number (or ENTER to quit): " reply >&2

        if [ -z "$reply" ] ; then
            echo "[quit]"
            return 1
        fi
        if [ -z "$(echo "$reply" | tr -d '0-9')" ] ; then
            if [ "$reply" -ge 1 ] && [ "$reply" -le ${#newdirs[@]} ] ; then
                echo "${newdirs[$((reply-1))]}"
                return 0
            fi
        fi
        echo "unsupported input '$reply'" >&2
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


    # Now we have the final tree data!

    if [ "$show_tree" = "yes" ] ; then
        echo "$treedata"
        return 2
    fi

    if [ "$whole_word_match" = "yes" ] ; then
        # find a "whole word" match (or many "whole word" matches)
        readarray -t newdir <<< "$(echo "$treedata" | /usr/bin/grep -P "/$path"$)"
    else
        # find a "non-exact" match (or many non-exact matches)
        readarray -t newdir <<< "$(echo "$treedata" | /usr/bin/grep -P "/$path"[^/]*$)"
    fi

    if [ "${newdir[0]}" != "" ] && [ "${newdir[1]}" != "" ] ; then
        newdir="$(NcdSelectFromList "${newdir[@]}")"
        [ $? -eq 0 ] || return 1
    fi
}


NcdChDir() {
    if [ -n "$1" ] ; then
        cd "$1" >/dev/null
    else
        cd
    fi
    [ "$show_dir" = "yes" ] && pwd | sed "s|^$HOME|~|"
}

NcdOptions() {
    # config file options
    
    local conf=$HOME/.config/ncd/ncd.conf
    local NCD_PATHS_OPTS
    local NCD_EXCLUDES_OPTS
    local NCD_OPTS
    local xx

    source $conf || return 1

    for xx in "${NCD_OPTS[@]}" ; do
        case "$xx" in
            --showdir) show_dir=yes ;;
            *)  echo "Error: unsupported parameter '$xx' in NCD_OPTS." >&2 ; exit 1 ;;
        esac
    done

    for xx in "${NCD_PATHS_OPTS[@]}" ; do
        case "$xx" in
            --follow-symlinks) follow_symlinks=yes ;;
            *)  echo "Error: unsupported parameter '$xx' in NCD_PATHS_OPTS." >&2 ; exit 1 ;;
        esac
    done

    for xx in "${NCD_EXCLUDES_OPTS[@]}" ; do
        case "$xx" in
            *)  echo "Error: unsupported parameter '$xx' in NCD_EXCLUDES_OPTS." >&2 ; exit 1 ;;
        esac
    done
}

NcdDirectMatch() {
    if [ -n "$zz" ] ; then
        for xx in "${zz[@]}" ; do
            [ -d "$xx" ] && yy+=("$xx")
        done
        if [ -n "$yy" ] ; then
            if [ "${#yy[@]}" -eq 1 ] ; then
                NcdChDir "$yy"
                return 0
            else
                yy="$(NcdSelectFromList "${yy[@]}")"
                [ $? -eq 0 ] || return 1
                NcdChDir "$yy"
                return 0
            fi
        fi
    fi
    return 1  # no match
}

NcdUsage() {
    cat <<EOF >&2
Usage:
         ncd option1
         ncd [option2] path

option1:
    -h | --help           This help.
    -hh                   This help and additional online help.
    -t | --show-tree      Show the list of paths where leaf folders will be searched.

option2:
    -w | --whole-word     Show only whole word matches for leafs instead of just head match.

path:
    - any path that 'cd' can handle, or
    - any 'leaf' folder name or the start of a 'leaf' folder name, without the leading parent path.
    A 'leaf' folder of '/usr/share/endeavouros' is 'endeavouros'.
    Examples:
        ncd endeavouros       (full leaf name)
        ncd endeavour         (start of leaf name)
        ncd ..                (relative path)
        ncd /usr/share        (full path)
        ncd -                 (back to the previous folder)
        ncd -w sound          (matches leaf 'sound' but not e.g. 'sounds')

Configuration files at ~/.config/ncd:
    ncd.conf
        Bash array variables:
            NCD_OPTS
                --showdir            Show the target folder name.
            NCD_PATHS_OPTS
                --follow-symlinks    Search for leaf folders "behind" symlinks.
            NCD_EXCLUDES_OPTS
                                     (Currently no options.)
        Example:
            NCD_OPTS=(--showdir)
            NCD_PATHS_OPTS=(--follow-symlinks)
            NCD_EXCLUDES_OPTS=()
    excludes
        Example (note: grep syntax for paths):
            /\.git/
            /\.git$
            /foobar/
    paths
        Example:
            ~/Documents
            ~/Pictures
EOF
}

ncd() {
    local arg
    local path
    local follow_symlinks=no                # safer default not to follow symlinks
    local show_dir=no
    local show_tree=no
    local whole_word_match=no

    for arg in "$@" ; do
        case "$arg" in
            --help | -h)
                NcdUsage
                return
                ;;
            -hh)
                xdg-open https://github.com/manuel-192/m-m/blob/master/PKGBUILDs/ncd/README.md 2>/dev/null
                ncd --help
                return
                ;;
            --show-tree | -t)
                show_tree=yes
                ;;
            --whole-word | -w)
                whole_word_match=yes
                ;;
            -*)
                if [ "$arg" = "-" ] ; then
                    path="$arg"
                else
                    NcdError "unsupported option '$arg'."
                    return 1
                fi
                ;;
            *)
                path="$arg"
                ;;
        esac
    done

    NcdOptions # options from config file

    if [ "$show_tree" = "no" ] ; then
        local xx yy=() zz

        # simple cases: use cd
        case "$path" in
            . | */. | .. | */.. | -)
                NcdChDir "$path" ; return ;;
            "")
                NcdChDir ; return ;;
        esac

        # Try a match using the $path directly.
        if [ "$whole_word_match" = "yes" ] ; then
            readarray -t zz <<< "$(/usr/bin/ls -d1 "$path" 2>/dev/null)"
            NcdDirectMatch && return 0
        else
            readarray -t zz <<< "$(/usr/bin/ls -d1 "$path"* 2>/dev/null)"
            NcdDirectMatch && return 0
        fi
    fi

    # Use predefined paths.

    local newdir
    NcdCandidates
    case "$?" in
        0) ;;
        1) return 1 ;;
        2) return 0 ;;
    esac
    
    if [ -d "$newdir" ] ; then
        NcdChDir "$newdir"
    else
        echo "Sorry, folder starting with '$path' not found." >&2
    fi
}
