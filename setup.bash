branch=${1:-master}
repo=${2:-~/.dotfiles}

githuburl=https://bellflower2015@github.com/bellflower2015/dotfiles.git

branch_exists(){
    local result=$(git branch --list $1|tr "*" " "|xargs)
    [ "$result" = "$1" ] && echo 0||echo 1
}

r_branch_exists(){
    local result=$(git branch -r|grep -v '\->'|sed -e 's!origin/\(.*\)$!\1!'|grep -w $1|xargs)
    [ "$result" = "$1" ] && echo 0||echo 1
}

[ ! -d $repo ] && git clone $githuburl $repo

pushd $repo

[ $(r_branch_exists $branch) -eq 0 ] && [ $(branch_exists $branch) -ne 0 ] && \
    git checkout -b $branch origin/$branch

git checkout $branch
git fetch --prune --tags
git pull --prune --tags origin $branch

for f in $repo/.??*; do
    [ "$f" = "$repo/.git" ] && continue
    ln -snfv $f ~/${f#$repo/}
done

popd && exec $SHELL -l
