branch=$1
dotpath=~/.dotfiles
export __dotfiles_log=$HOME/.dotfiles.initlog

githuburl=https://bellflower2015@github.com/bellflower2015/dotfiles.git

function init_log() {
    unlink $__dotfiles_log 2>/dev/null
    echo "" | tee $__dotfiles_log
}

function echo_log() {
    echo "$1" | tee -a $__dotfiles_log
}

function echo_n_log() {
    echo -n "$1" | tee -a $__dotfiles_log
}

function echo_e_log() {
    echo -e "$1" | tee -a $__dotfiles_log
}

function current_branch(){
    local result=$(git branch --list|grep '*'|tr "*" " "|xargs)
    echo $result
}

function branch_exists(){
    local result=$(git branch --list $1|tr "*" " "|xargs)
    [ "$result" = "$1" ] && echo 0||echo 1
}

function r_branch_exists(){
    local result=$(git branch -r|grep -v '\->'|sed -e 's!origin/\(.*\)$!\1!'|grep -w $1|xargs)
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
    git checkout -b $branch origin/$branch 2>&1 | tee -a $__dotfiles_log

[ "$__dotfiles_new" = "new" ] && git checkout $branch 2>&1 | tee -a $__dotfiles_log
git fetch --prune --tags 2>&1 | tee -a $__dotfiles_log
git pull --prune --tags origin $branch 2>&1 | tee -a $__dotfiles_log

echo_log
echo_log
echo_e_log "\e[31m*\e[m Set \e[32msymlinks\e[m:"
echo_log
for f in $dotpath/.??*; do
    [ "$f" = "$dotpath/.git" ] && continue
    ln -snfv $f ~/${f#$dotpath/} 2>&1 | tee -a $__dotfiles_log
done
echo_log

popd >/dev/null 2>&1 && exec $SHELL -l
