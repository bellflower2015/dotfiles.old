unalias ls 2>/dev/null

if [ "$(type gnuls 2>/dev/null)" ]; then
    alias ls='gnuls --color=auto'
elif [ "$(type gls 2>/dev/null)" ]; then
    alias ls='gls --color=auto'
elif [ "$(ls --color 2>/dev/null)" ]; then
    alias ls='ls --color=auto'
elif [ "$(ls -G 2>/dev/null)" ]; then
    alias ls="ls -G"
fi

alias ll='ls -alF'
