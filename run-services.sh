#!/bin/sh


if [[ ! -f /root/.first_run ]]; then
    cp -p /conf/nginx/license.key /etc/wallarm/
    chown root:wallarm /etc/wallarm/license.key
    sed -i "s/SLAB_ALLOC_ARENA=.*/SLAB_ALLOC_ARENA=${SLAB_ALLOC_ARENA:-"0.2"}/g" /etc/sysconfig/wallarm-tarantool
    /usr/share/wallarm-common/addnode -u ${WALLARM_USER} -p ${WALLARM_PASSWORD} -n ${WALLARM_NODENAME:-"wallarm-`hostname`"} -f
    touch /root/.first_run
fi

. /functions.sh

reload_nginx_config

trap "/sbin/service nginx-wallarm stop; /sbin/service wallarm-tarantool stop; killall reloader.sh; killall etcdctl; killall tail; exit 0" SIGINT SIGTERM SIGHUP

/sbin/service wallarm-tarantool start
/sbin/service nginx-wallarm start 

touch /var/log/container.log
tail -F /var/log/container.log &

ETCDCTL_NOTIFY=${ETCDCTL_NOTIFY:-"/services/nginx/notify"}

if [ ! -z "${ETCDCTL_PEERS}" ] ; then
    export ETCDCTL_PEERS
    export ETCDCTL_NOTIFY
    /reloader.sh ${ETCDCTL_WATCH} &
fi


wait

