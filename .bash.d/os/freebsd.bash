# さくらのレンタルサーバかどうか
# さくらぽけっと用ディレクトリの有無で判別
function is_srs() {
    [ -e $HOME/sakura_pocket ] && echo 1 || echo 0
}

srs=`is_srs`
[ $srs -eq 1 ] && read_file $basedir/misc/srs.bash
