# Kept getting errors after sourcing the original steam ~/.bashrc, so...

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ssh
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
ssh-add ~/.ssh/*_rsa

# dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias ls='ls --color=auto'
if command -v grep >/dev/null
then
        alias grep='grep --color=auto'
fi
PS1='(\u@\h \W)\$ '

# Hack for the Qemu serial
if [[ $(tty) == /dev/ttyS0 ]]
then
        TERM=linux
        eval "$(resize)"
fi


