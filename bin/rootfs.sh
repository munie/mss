#!/bin/sh

usage()
{
	echo "Usage: toolchian.sh {COMMAND} [PREFIX]"
	echo ""
	echo "    {COMMAND}"
	echo "    [PREFIX]  where to install the toolchain [default: ./_install]"
}

# usage
[ -z "$1" ] || [ "$1" == "--help" ] && usage && exit

# environment
SCRIPT_PATH=$0
BASEDIR=${SCRIPT_PATH%/*}
#cd $BASEDIR; [ ! -z "$2" ] && PREFIX=$(pwd)/$2 || PREFIX=$(pwd)/_install; cd -
[ ! -z "$2" ] && PREFIX=$BASEDIR/$2 || PREFIX=$BASEDIR/_install
COMMAND=$(tr [A-Z] [a-z] <<<$1)

build_rootfs()
{
	mkdir -p $PREFIX
	cd $PREFIX
	mkdir -p bin sbin lib etc usr var dev proc sys tmp && chmod 1777 tmp
	mkdir -p etc/init.d etc/udev && touch etc/inittab etc/fstab etc/init.d/rcS
	mkdir -p usr/bin usr/sbin usr/lib usr/include usr/share usr/src
	mkdir -p var/lib var/lock var/log var/run var/tmp && chmod 1777 var/tmp
	sudo mknod -m 600 dev/mem c 1 1
	sudo mknod -m 666 dev/null c 1 3
	sudo mknod -m 666 dev/zero c 1 5
	sudo mknod -m 644 dev/random c 1 8
	sudo mknod -m 600 dev/tty0 c 4 0
	sudo mknod -m 600 dev/tty1 c 4 1
	sudo mknod -m 600 dev/ttyS0 c 4 64
	sudo mknod -m 666 dev/tty c 5 0
	sudo mknod -m 600 dev/console c 5 1
	ln -sf /proc/self/fd/ dev/fd
	ln -sf /proc/self/fd/0 dev/stdin
	ln -sf /proc/self/fd/1 dev/stdout
	ln -sf /proc/self/fd/2 dev/stderr
	cd -
}

build_rootfs

sudo chown -R 0:0 $PREFIX
