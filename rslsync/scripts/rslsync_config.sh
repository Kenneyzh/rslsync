#!/bin/sh
#2017/06/28 by kenney
#version 0.1

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export rslsync_`
conf_Path="$KSROOT/rslsync/config"
export HOME=/root
export LD_LIBRARY_PATH=/jffs/koolshare/lib:$LD_LIBRARY_PATH

create_conf(){
    if [ ! -d $conf_Path ];then
        $KSROOT/bin/rslsync -generate=$conf_Path >>/tmp/rslsync.log
    fi
}
lan_ip=`nvram get lan_ipaddr`
weburl="http://$lan_ip:$rslsync_port"
get_ipaddr(){
    if [ $rslsync_wan_enable == 1 ];then
        ipaddr="0.0.0.0:$rslsync_port"
    else
        ipaddr="$lan_ip:$rslsync_port"
    fi
}
start_rslsync(){
    $KSROOT/bin/rslsync  --webui.listen $ipaddr &
    #cru d rslsync
    #cru a rslsync "*/10 * * * * sh $KSROOT/scripts/rslsync_config.sh"
    dbus set rslsync_webui=$weburl
    if [ -L "$KSROOT/init.d/S94rslsync.sh" ];then 
        rm -rf $KSROOT/init.d/S94rslsync.sh
    fi
    ln -sf $KSROOT/scripts/rslsync_config.sh $KSROOT/init.d/S94rslsync.sh
}
stop_rslsync(){
    for i in `ps |grep rslsync|grep -v grep|grep -v "/bin/sh"|awk -F' ' '{print $1}'`;do
        kill $i
    done
    sleep 2
    #cru d rslsync
    if [ -L "$KSROOT/init.d/S94rslsync.sh" ];then 
        rm -rf $KSROOT/init.d/S94rslsync.sh
    fi
    dbus set rslsync_webui="--"
}

case $ACTION in
start)
	if [ "$rslsync_enable" = "1" ]; then
        #create_conf
        get_ipaddr
        start_rslsync
	fi
	;;
stop)
	stop_rslsync
	;;
*)
    if [ "$rslsync_enable" = "1" ]; then
        if [ "`ps|grep rslsync|grep -v "/bin/sh"|grep -v grep|wc -l`" != "0" ];then 
            stop_rslsync
        fi
        #create_conf
        get_ipaddr
        start_rslsync
	else
        stop_rslsync
    fi
    http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
	;;
esac
