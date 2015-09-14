unalias ls 2>/dev/null

alias ls="ls -G"
if [ "$(type gnuls 2>/dev/null)" ]; then
    alias ls='gnuls --color=auto'
elif [ "$(type gls 2>/dev/null)" ]; then
    alias ls='gls --color=auto'
elif [ "$(/bin/ls --version 2>&1 | grep -s GNU)" ]; then
    alias ls='ls --color=auto'
fi

alias ll='ls -alF'
