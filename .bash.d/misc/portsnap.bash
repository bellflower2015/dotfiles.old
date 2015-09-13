export INSTALL_AS_USER=yes
export PREFIX=${HOME}/opt
export LOCALBASE=${HOME}/opt
export PKG_DBDIR=${LOCALBASE}/var/db/pkg
export PKG_TMPDIR=${LOCALBASE}/tmp/
export PORT_DBDIR=${LOCALBASE}/var/db/pkg
export DISTDIR=${LOCALBASE}/tmp/dist
export WRKDIRPREFIX=${LOCALBASE}/tmp/work
export PORTSDIR=${LOCALBASE}/ports
export PKGTOOLS_CONF=${LOCALBASE}/etc/pkgtools.conf
export DEPENDS_TARGET='install clean'

export X11BASE=${LOCALBASE}

export PKG_CONFIG_PATH="$HOME/opt/lib/pkgconfig:$HOME/opt/libdata/pkgconfig:/usr/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/libdata/pkgconfig:/usr/libdata/pkgconfig"

# Set user and group variables to ourself
export BINOWN=`whoami`
export BINGRP=`id -G -n ${BINOWN}`
export SHAREOWN=${BINOWN}
export SHAREGRP=${BINGRP}
export MANOWN=${BINOWN}
export MANGRP=${BINGRP}

# Make sure files are installed with correct default permissions
export BINMODE=755
export SHAREMODE=644
export MANMODE=644

# Make sure we don't really try to become root, but just execute everything as ourselves
export SU_CMD="sh -c"

# Make sure the systemdefault make.conf is not read
export __MAKE_CONF=${LOCALBASE}/etc/make.conf

# Keep our own version of ldconfig hints
export LDCONFIG="/sbin/ldconfig -i -f ${LOCALBASE}/var/run/ld-elf.so.hints"
#export LDCONFIG="/sbin/ldconfig -f=${LOCALBASE}/var/run/ld-elf.so.hints -i -R=${LOCALBASE}/etc/ld-elf.so.conf "
export LD_LIBRARY_PATH=${LOCALBASE}/lib:${LOCALBASE}/lib/nss
export LD_RUN_PATH=${LOCALBASE}/lib:${LOCALBASE}/lib/nss

export PATH=${LOCALBASE}/bin:${LOCALBASE}/sbin:${PATH}
export MANPATH_MAP=${LOCALBASE}/bin:${LOCALBASE}/man

if [ -f $LOCALBASE/bin/python2.7 ]; then
    export PYTHON2=$LOCALBASE/bin/python2.7
    alias python=$PYTHON2
fi

alias portsnap="portsnap -f $LOCALBASE/etc/portsnap.conf"
