#!/bin/bash

##===================Pull updates on GTG Modules====
## execting pulling updates at the end makes it a little
## easier to integrate GTG module updates.
##==================================================
#cd /var/www/html/sites/all/modules/GTG_modules/galaxy_tool_generator && git pull origin master
#cd /var/www/html/sites/all/modules/GTG_modules/galaxy_tool_generator_ui && git pull origin master
#cd /var/www/html/sites/all/modules

## start postgresql
rm -rf /var/lib/pgsql/data/postmaster.pid
sudo -u postgres pg_ctl start -D /var/lib/pgsql/data/ > /dev/null 2>&1
echo
echo "starting Galaxy Tool Generator..."
echo
sleep 5

##
# sh -c "$@"
## start apache
rm -f /usr/local/apache2/logs/httpd.pid
/usr/sbin/httpd -DFOREGROUND