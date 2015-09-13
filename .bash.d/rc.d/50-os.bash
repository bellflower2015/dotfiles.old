function read_os_file() {
    local osdir=$1
    local ostype=`get_ostype`
    read_file $osdir/$ostype.bash
}

read_os_file $basedir/os
