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

if [ -r /etc/skel/cd.bash ] && [ -r $HOME/.config/cd.conf ] ; then
    source $HOME/.config/cd.conf
    source /etc/skel/cd.bash
else
    echo "Info: 'cd-path' not installed." >&2
fi

_try_alias() {
    # do alias only if the name is not assigned to something already
    local name="$1"
    local def="$2"
    type "$name" >& /dev/null || alias "$name"="$def"
}


open-anything() {
    {
        local app=exo-open
        if ! which $app ; then
            app=xdg-open
        fi
        setsid $app "$@"
    } >& /dev/null
}

lsd()   { find . -type d -exec ls -ld {} \; ; }
drw()   {
    # shellcheck disable=SC2010
    ls -l "$@" | grep rw
}

welcome()  { setsid eos-welcome --once "$@" ; }

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

_pkgcheck_init ; unset -f _pkgcheck_init

_try_alias ll 'ls -lav --ignore=..'         ## show long listing of all except ".."
_try_alias l  'ls -lav --ignore=.?*'        ## show long listing but no hidden dotfiles except "."
_try_alias p  "pacman-ext --extras --no-banner --expac"
# alias pacman=pacman-ext         # maybe not the best idea ...

alias branch="pacman-conf --repo-list | grep '^testing$' || echo stable"
alias meld=meld-rcs                         # setsid fails with 'read' !!
alias o=open-anything
alias pacdiff=eos-pacdiff                   ## use pacdiff with meld
alias ramsleep='Power-routines suspend'     ## package abbrevs-misc
alias sou="source ~/.bashrc"


[ -z "$FUNCNEST" ] && export FUNCNEST=100   ## limits recursion in bash functions, see 'man bash'

[ -x /usr/bin/meld ] && export DIFFPROG=meld
export HISTCONTROL="erasedups"
export HISTSIZE=20
export HISTFILESIZE=10
export HISTFILE=""
unset  HISTFILE

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
#
if [ "${-/*i*/i}" = "i" ] ; then             # is interactive shell?
    bind '"\e[A":history-search-backward'    # up arrow
    bind '"\e[B":history-search-forward'     # down arrow

    bind 'set show-all-if-ambiguous on'        # complete with single TAB
    bind 'set mark-symlinked-directories on'   # complete directory symlinks with slash
fi

shopt -s autocd
