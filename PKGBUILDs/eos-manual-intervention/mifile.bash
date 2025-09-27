#!/bin/bash

# Available hotfixes.

# Helpers:
#   RUN
#   WARN

# Functions

MI_20250621() {
    local pkg=linux-firmware
    local curver="$(expac %v $pkg)"
    local newver=20250613.12fe085f-5
    if [ "$curver" ] ; then
        if [ $(vercmp $curver $newver) -lt 0 ] ; then
            RUN sudo pacman -Rsn $pkg || return 1
            RUN sudo pacman -Syu $pkg || return 1
        fi
        return 0
    else
        WARN "$pkg is not installed"
        return 1
    fi
}

MI_20250620() {
    local pkg=plasma-x11-session
    if [ -e /usr/share/wayland-sessions/plasma.desktop ] ; then
        if [ ! -e /usr/share/xsessions/plasmax11.desktop ] ; then
            read -p "Do you want to support x11 sessions (yes/no)? " >&2
            case "$REPLY" in
                [yY]*) RUN sudo pacman -Syu $pkg || return 1 ;;
            esac
        fi
    fi
}

# Add each function name and description into this array:
MI_func_names=(
    MI_20250621 "linux-firmware"
    MI_20250620 "x11 plasma session"
)
