export DOTFILESDIR=$HOME/.dotfiles
export DOTFILES_INITLOG=$HOME/.dotfiles.initlog
export DOTFILES_LOG=$HOME/.dotfiles.log

basedir="$HOME/.bash.d"
color_on="\e[32m"
color_off="\e[m"
indentnum=0

function init_log() {
    unlink $DOTFILES_LOG 2>/dev/null
    echo "" | tee $DOTFILES_LOG
}

function echo_log() {
    echo "$*" | tee -a $DOTFILES_LOG
}

function echo_n_log() {
    echo -n "$*" | tee -a $DOTFILES_LOG
}

function echo_e_log() {
    echo -e "$*" | tee -a $DOTFILES_LOG
}

function uniq_env() {
    local name=${1:-PATH}
    local val; eval val=\"\$$name\"
    export $name="$(echo $val | tr ':' '\n' | sed '/^$/d' | awk '!a[$0]++' | paste -d: -s -)"
}

function append_env() {
    local name=${1:-PATH}
    local val; eval val=\"\$$name\"
    printf -v "$name" "%s" "$val:$2"
    uniq_env $name
}

function prepend_env() {
    local name=${1:-PATH}
    local val; eval val=\"\$$name\"
    printf -v "$name" "%s" "$2:$val"
    uniq_env $name
}

function uniq_path()    { uniq_env    PATH     ; }
function append_path()  { append_env  PATH "$*"; }
function prepend_path() { prepend_env PATH "$*"; }

function base_name() {
    echo ${1##*/}
}

function dir_name() {
    echo ${1%/*}
}

function read_file() {
    local file=$1

    #local path="~/${file#$HOME/}"
    local path="$file"
    local dir=$(dir_name "$path")
    local base=$(base_name "$path")
    if [ -r "$file" ]; then
        indent=""
        if [ $indentnum -gt 0 ]; then
            for ((i=0;i<$indentnum;i++)); do indent="  "$indent; done
        fi
        echo_n_log "  ${indent}- $dir/"
        echo_e_log "${color_on}${base}${color_off}"
        indentnum=$((indentnum+1))
        . "$file"
        indentnum=$((indentnum-1))
    fi
}

function read_dir() {
    local f
    find "$1" -name "$2" -type f | while read f
    do
        read_file "$f"
    done
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

function dotfiles() {
    PROGNAME=dotfiles
    VERSION="0.1.0"
    EXIT=0
    
    function usage() {
        echo "Usage: $PROGNAME OPTIONS"
        echo "  This script is bellflower's dotfiles utility."
        echo "  see https://github.com/bellflower2015/dotfiles"
        echo
        echo "Options:"
        echo "  -h, --help"
        echo "  -l, --log"
        echo "  -r, --reload"
        echo "  -v, --version"
        echo
    }
    
    for OPT in "$@"
    do
        case "$OPT" in
            '-h'|'--help' )
                usage
                EXIT=1
                ;;
            '-v'|'--version' )
                echo $VERSION
                EXIT=1
                ;;
            '-r'|'--reload' )
                eval "$(cat $DOTFILESDIR/setup.bash)"
                EXIT=1
                ;;
            '-l'|'--log' )
                shift 1
                [ -r $DOTFILES_INITLOG ] && cat $DOTFILES_INITLOG
                [ -r $DOTFILES_LOG ] && cat $DOTFILES_LOG
                EXIT=1
                ;;
            '--'|'-' )
                shift 1
                param+=( "$@" )
                break
                ;;
            -*)
                echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
                ;;
            *)
                if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
                    #param=( ${param[@]} "$1" )
                    param+=( "$1" )
                    shift 1
                fi
                ;;
        esac
    done

    [ -z $param ] && [ $EXIT -ne 1 ] && usage
}

init_log
echo_e_log "\e[31m*\e[m Loaded the init ${color_on}scripts${color_off} in the following order:"
echo_log

append_path "$HOME/.dotfiles/bin"

echo_e_log "- $HOME/${color_on}.bashrc${color_off}"
[ -d "$basedir" ] && read_dir "$basedir/rc.d" "*.bash"
read_file "$HOME/.bashrc.local"
echo_log

uniq_path
echo_log
echo_e_log "\e[31m*\e[m ${color_on}PATH${color_off} Environment:"
echo_log
function path_list() {
    local IFS="$IFS"
    local source="$*"
    local -a ary

    IFS=':'
    ary=(${source})
    for p in "${ary[@]}"; do
        echo_log "  - $p"
    done
}
path_list $PATH
echo_log

#--------------------------------------

unset indentnum
unset color_off
unset color_on
unset basedir
