unalias ls 2>/dev/null

if [ "$(type gnuls 2>/dev/null)" ]; then
    alias ls='gnuls --color=auto'
elif [ "$(type gls 2>/dev/null)" ]; then
    alias ls='gls --color=auto'
elif [ "$(/bin/ls --version 2>/dev/null| grep -s GNU)" ]; then
    alias ls='ls --color=auto'
else
    alias ls='ls -G'
fi

alias ll='ls -alF'
