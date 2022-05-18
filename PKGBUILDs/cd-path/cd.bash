#!/bin/bash

# A 'cd' designed for CDPATH.
#
# Can specify folders to be excludes using variables:
#   - CDPATH_EXCLUDE      array of (absolute and relative) folders
#   - CDPATH_EXCLUDE_FILES files (likely an empty file) in a folder

_cd_out() {
    if [ "$CDOUT" = "all" ] ; then
        if [ -z "$2" ] ; then
            echo "==> $1" >&2
        else
            echo "    $1" >&2
        fi
    fi
}

_cd_out_important() {
    local old_cdout="$CDOUT"
    CDOUT=all
    _cd_out "$@"
    CDOUT="$old_cdout"
}

_cd_is_unique_value() {
    local value="$1"
    local xx
    shift

    for xx in "$@" ; do
        if [ "$value" = "$xx" ] ; then
            return 1
        fi
    done
    return 0
}

_cd_builtin_cd() {
    builtin cd $opts "$@" || _cd_out_important "failed: cd $opts $*"
}

cd() {
    local arg
    local newdir=""
    local realpath=/usr/bin/realpath
    local conf=$HOME/.config/cd.conf
    local opts=""

    if [ ! -r $conf ] ; then
        if [ -r /etc/skel/cd.conf ] ; then
            _cd_out_important "Copying /etc/skel/cd.conf to $conf."
            _cd_out_important "Please make sure $conf contains useful settings!"
            cp /etc/skel/cd.conf $HOME/.config/
        else
            _cd_out_important "You need to have a proper config file $conf!"
            _cd_out_important "/etc/skel/cd.conf was not found either."
        fi
        return 1
        # RunInTerminal nano $HOME/.config/cd.conf
    fi
    if [ -z "CDPATH_ARR" ] && [ -z "$CDPATH_EXCLUDE" ] ; then
        source $conf || return 1
        export CDPATH="$(echo "${CDPATH_ARR[@]}" | tr ' ' ':')"
    fi

    case "$CDOUT" in
        all | important) ;;
        *) _cd_out_important "value of CDOUT in file $conf is unsupported!" ; return 1 ;;
    esac

    # handle options
    for arg in "$@" ; do
        case "$arg" in
            -)
                if [ -n "$newdir" ] ; then
                    _cd_out_important "please give only one target dir"
                    return 1
                fi
                newdir="$arg"
                ;;
            -L | -P | -e | "-@")
                opts+=" $arg"
                ;;
            -*) _cd_out_important "unsupported option $arg" ; return 1 ;;
            *)
                if [ -n "$newdir" ] ; then
                    _cd_out_important "please give only one target dir"
                    return 1
                fi
                newdir="$arg"                                       # this is where we want to go!
                if [ "$newdir" != "/" ] && [ "${newdir: -1}" = "/" ] ; then
                    newdir=${newdir:: -1}  # remove possible trailing slash
                fi
                ;;
        esac
    done

    local dir dirs=() ix dir2 file
    local newdir_excluded_by=()
    local excluded_dir="" excluded

    # First handle some simple cases (note: these allow an excluded path!)
    case "$newdir" in
        - | "")
            _cd_out "special paths"
            _cd_builtin_cd $newdir
            return
            ;;
        /*)
            if [ -d "$newdir" ] ; then
                _cd_out "accept all existing absolute paths"
                _cd_builtin_cd "$newdir"
                return
            fi
            ;;
        *)
            if [ -d ./"$newdir" ] ; then
                _cd_out "accept all existing relative paths"
                _cd_builtin_cd ./"$newdir"
                return
            fi
            ;;
    esac

    # Now we'll search for CDPATH and CDPATH_EXCLUDE.
    # $newdir
    #  - is not empty
    #  - is a relative path
    #  - has no trailing slash

    # Find all matches that are not excluded
    for dir in "${CDPATH_ARR[@]}" ; do
        if [ -d "$dir/$newdir" ] ; then
            excluded_dir=""
            for dir2 in "${CDPATH_EXCLUDE[@]}" ; do
                if [ "$dir2" = "$newdir" ] || [ "$dir2" -ef "$dir/$newdir" ] || [ "$dir2" -ef "$newdir" ] ; then
                    excluded_dir="$dir2"
                    if (_cd_is_unique_value "$excluded_dir" "${newdir_excluded_by[@]}") ; then
                        newdir_excluded_by+=("$excluded_dir")           # exclude absolute or relative path
                    fi
                    break
                fi
            done
            if [ -z "$excluded_dir" ] ; then
                excluded=no
                for file in "${CDPATH_EXCLUDE_FILES[@]}" ; do
                    if [ -r "$dir/$newdir/$file" ] ; then
                        newdir_excluded_by+=("$dir/$newdir/$file")
                        excluded=yes
                        break
                    fi
                done
                if [ "$excluded" = "no" ] ; then
                    if [ "$dir" = "/" ] ; then
                        dirs+=("/$newdir")      # avoid two slash names like //folder
                    else
                        dirs+=("$dir/$newdir")
                    fi
                fi
            fi
        fi
    done

    # Now we have all possible matches in $dirs.
    # Do final touch.

    case "${#dirs[@]}" in
        1)  _cd_out "one match"
            _cd_builtin_cd "${dirs[0]}"
            ;;
        0)  if [ -n "$newdir_excluded_by" ] ; then
                _cd_out_important "excluded by '${newdir_excluded_by[*]}'"
            else
                _cd_out_important "'$newdir': no match found in CDPATH_ARR."
            fi
            ;;
        *)
            # Many matches, round robin them.
            # If $PWD matches, go to the next match!
            for ((ix=0; ix < ${#dirs[@]}; ix++)) ; do
                dir="${dirs[$ix]}"
                if [ "$dir" -ef "$PWD" ]; then
                    ((ix++))
                    [ $ix = ${#dirs[@]} ] && ix=0
                    _cd_out "one of many matches"
                    _cd_builtin_cd "${dirs[$ix]}"
                    return
                fi
            done

            # Go to the first of many matches. Inform about more matches!
            _cd_out_important "${#dirs[@]} matches (run again for the next):"
            for ((ix=0; ix < ${#dirs[@]}; ix++)) ; do
                dir="${dirs[$ix]}"
                case "$dir" in
                    "$HOME"*) dir="~${dir:${#HOME}}" ;;
                esac
                _cd_out_important "$dir" no
            done
            _cd_out "first of many matches:"
            _cd_builtin_cd "${dirs[0]}"
            ;;
    esac
}
