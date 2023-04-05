#!/bin/bash

# source this file in your ~/.bashrc

_apps_to_funcs_init() {
    local apps=(
        adie
        audacity
        bluefish
        chromium
        dolphin
        eclipse
        firefox
        firefox-developer-edition
        geany
        gedit
        ghostwriter
        gitk
        gnome-boxes
        gnome-builder
        kate
        kdevelop
        konsole
        libreoffice
        mousepad
        notepadqq
        opera
        pamac-manager
        parole
        qterminal
        ristretto
        soffice
        terminator
        thunderbird
        tkdiff
        xed
        xfce4-screenshooter
        xplayer
        xreader
    )
    apps+=(        # here for other reasons!
        kaffeine
        krusader
        vivaldi-stable
    )
    local pr
    local tmpfile=$(mktemp)

    for pr in "${apps[@]}" ; do
        if [ -x /usr/bin/$pr ] ; then
            # echo "$pr() { _bg_func \"\$@\" ; }" >> $tmpfile
            cat <<EOF >> $tmpfile
$pr() {
  if [ -x /usr/bin/$pr ] ; then
    case "\$1" in
      -h | --help*)
        /usr/bin/$pr "\$@" 2> /dev/null ;;
      *)
        setsid /usr/bin/$pr "\$@" &> /dev/null ;;
    esac
  else
    command $pr  # gives a warning!
  fi
}
EOF
        fi
    done
    if [ -f $tmpfile ] ; then
        # shellcheck disable=SC1090
        source $tmpfile
        rm -f $tmpfile
    fi
}

_apps_to_funcs_init

unset -f _apps_to_funcs_init

