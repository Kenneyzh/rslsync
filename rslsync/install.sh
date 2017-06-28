#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

cp -r /tmp/rslsync/* $KSROOT/
chmod a+x $KSROOT/scripts/rslsync_*
chmod a+x $KSROOT/bin/rslsync

# add icon into softerware center
dbus set softcenter_module_rslsync_install=1
dbus set softcenter_module_rslsync_version=0.1
dbus set softcenter_module_rslsync_description="Resilio Sync 同步工具"
rm -rf $KSROOT/install.sh