branch=$1
dotpath=~/.dotfiles
logfile=$HOME/.dotfiles.initlog

githuburl=https://github.com/bellflower2015/dotfiles.git

function init_log() {
    unlink $logfile 2>/dev/null
    echo "" | tee $logfile
}

function echo_log() {
    echo "$1" | tee -a $logfile
}

function echo_n_log() {
    echo -n "$1" | tee -a $logfile
}

function echo_e_log() {
    echo -e "$1" | tee -a $logfile
}

function current_branch(){
    local result=$(git branch|grep '*'|tr "*" " "|xargs)
    echo $result
}

function branch_exists(){
    local result=$(git branch|tr '*' ' '|grep -w $1|xargs)
    [ "$result" = "$1" ] && echo 0||echo 1
}

function r_branch_exists(){
    local result=$(git branch -r|grep -v 'HEAD'|sed -e 's!origin/!!'|grep -w $1|xargs)
    [ "$result" = "$1" ] && echo 0||echo 1
}

[ ! -d $dotpath ] && __dotfiles_new='new' && git clone $githuburl $dotpath

pushd $dotpath >/dev/null 2>&1
[ "$__dotfiles_new" != "new" ] && branch=$(current_branch)
[ -z "$branch" ] && branch=master

init_log

echo_log
echo_e_log "\e[31m*\e[m Target branch: \e[32m$branch\e[m"
echo_log

[ $(r_branch_exists $branch) -eq 0 ] && [ $(branch_exists $branch) -ne 0 ] && \
    git checkout -b $branch origin/$branch 2>&1 | tee -a $logfile

[ "$__dotfiles_new" = "new" ] && git checkout $branch 2>&1 | tee -a $logfile
git fetch --prune 2>&1 | tee -a $logfile
git pull origin $branch 2>&1 | tee -a $logfile

echo_log
echo_log
echo_e_log "\e[31m*\e[m Set \e[32msymlinks\e[m:"
echo_log
for f in $dotpath/.??*; do
    [ "$f" = "$dotpath/.git" ] && continue
    [ "$f" = "$dotpath/.gitignore" ] && continue
    ln -snfv $f ~/${f#$dotpath/} 2>&1 | tee -a $logfile
done
echo_log

eval "$(curl -fsSL raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh)"

popd >/dev/null 2>&1 && exec $SHELL -l
