if ! $(type __git_ps1 &> /dev/null); then
    __git_ps1() { git branch 2> /dev/null | grep '*' | sed 's/* \(.*\)/ (\1)/'; }
fi
export PS1='[\[\033[32m\]\u@\H\[\033[00m\] \[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]]\$ '
