basedir=$HOME/.bash.d

color_on="\e[32m"
color_off="\e[m"
indentnum=0

function base_name() {
    echo ${1##*/}
}

function dir_name() {
    echo ${1%/*}
}

function indent() {
    if [ $indentnum -gt 0 ]; then
        for ((i=0;i<$indentnum;i++)); do echo -n "  "; done
        echo ""
    fi
}

function read_file() {
    local file=$1
    local indentstr=`indent`

    local path="~/${file#$HOME/}"
    local dir=$(dir_name $path)
    local base=$(base_name $path)
    if [ -r $file ]; then
        echo -n "  ${indentstr}- $dir/"
        echo -e "${color_on}${base}${color_off}"
        indentnum=$((indentnum+1))
        . $file
        indentnum=$((indentnum-1))
    fi
}

function read_dir() {
    local f
    for f in $@; do read_file $f; done
}

function get_ostype() {
    local os
    case $OSTYPE in
        darwin*)  os=darwin  ;;
        linux*)   os=linux   ;;
        freebsd*) os=freebsd ;;
        msys*)    os=msys    ;;
        *)        os=other   ;;
    esac
    echo $os
}

echo -e "- ~/${color_on}.bashrc${color_off}"
[ -d $basedir ] && read_dir $basedir/rc.d/*.bash
read_file $HOME/.bashrc.local

unset indentnum
unset basedir

echo ""
