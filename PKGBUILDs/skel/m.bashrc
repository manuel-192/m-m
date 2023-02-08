#!/bin/bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

##--------------------------------------------------
## EndeavourOS additions
##--------------------------------------------------

[ -z "$FUNCNEST" ] && export FUNCNEST=100   ## limits recursion in bash functions, see 'man bash'

alias ll='ls -lav --ignore=..'              ## show long listing of all except ".."
alias l='ls -lav --ignore=.?*'              ## show long listing but no hidden dotfiles except "."
alias pacdiff=eos-pacdiff                   ## use pacdiff with meld
alias meld='setsid meld-rcs'

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
#
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# aliases for EOS package building
alias p=pacman-ext

# other eos related aliases

# alias pacman=pacman-ext         # maybe not the best idea ...

welcome() { setsid eos-welcome --once "$@" ; }

_pkgcheck_init() {
    if [ -r /usr/share/bash-completion/completions/pkgcheck ] ; then
        source /usr/share/bash-completion/completions/pkgcheck
        local xx
        for xx in rc
        do
            alias $xx=pkgcheck
            complete -F _pkgcheck_ $xx
        done
    fi
}
_pkgcheck_init
