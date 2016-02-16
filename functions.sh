

reload_nginx_config() {
	if [ -d /tmp/nginx ] ; then
	    rm -rf /tmp/nginx
	fi
	# Create temporary config for Nginx
	cp -r /etc/nginx-wallarm /tmp/
	# Add/overwrite new files there
	cp -rf /conf/nginx /tmp/
	# Check new configuration of Nginx
	/usr/sbin/nginx-wallarm -t -p /tmp/nginx -c nginx.conf
	if [ $? -eq 0 ] ; then
	    # Copy tested configuration to production and reload
	    cp -rfp /tmp/nginx /etc/
	    /sbin/service nginx-wallarm reload
	    etcdctl set ${ETCDCTL_NOTIFY} reloaded
	    echo "New configuration applied"
	else
	    etcdctl set ${ETCDCTL_NOTIFY} error
	    echo "New configuration NOT applied"
	fi
	
	rm -rf /tmp/nginx
}