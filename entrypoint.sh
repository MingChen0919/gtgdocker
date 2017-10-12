#!/bin/bash

## start apache
rm -f /usr/local/apache2/logs/httpd.pid
/usr/sbin/httpd

## start postgresql
rm -rf /var/lib/pgsql/data/postmaster.pid
sudo -u postgres pg_ctl start -D /var/lib/pgsql/data/ > /dev/null 2>&1
echo
echo "starting Galaxy Tool Generator..."
echo
sleep 5
echo
echo "Galaxy Tool Generator is ready at http://127.0.0.1:8090/"
echo

## starting galaxy
#sh /root/galaxy/run.sh --daemon
#echo 'starting galaxy'
#sleep 60

##
sh -c "$@"