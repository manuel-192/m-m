#!/bin/bash

Pkgver() { pacman -Q "$1" 2>/dev/null | awk '{print $NF}' | cut -d'-' -f1 ; }

Main()
{
    local extensions vb

    extensions=$(Pkgver virtualbox-ext-oracle)
    [ -n "$extensions" ] || return 0

    vb=$(Pkgver virtualbox)
    [ -n "$vb" ] || return 0

    if [ "$vb" != "$extensions" ] ; then
        printf "\n==> You probably should run command: yay -Sua virtualbox-ext-oracle\n\n"
    fi
}

Main "$@"
