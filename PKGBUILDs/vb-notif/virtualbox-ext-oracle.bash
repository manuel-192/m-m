#!/bin/bash

Pkgver() { pacman -Q "$1" | awk '{print $NF}' | cut -d'-' -f1 ; }

Main()
{
    local extensions vb

    extensions=$(Pkgver virtualbox-ext-oracle)
    [ -n "$extensions" ] || return

    vb=$(Pkgver virtualbox)
    [ -n "$vb" ] || return

    if [ "$vb" != "$extensions" ] ; then
        printf "\n==> You probably should run command: yay -Sua virtualbox-ext-oracle\n\n"
    fi
}

Main "$@"
