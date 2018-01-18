#!/bin/bash

## start postgresql
rm -rf /var/lib/pgsql/data/postmaster.pid
sudo -u postgres pg_ctl start -D /var/lib/pgsql/data/ > /dev/null 2>&1
echo
echo "starting Galaxy Tool Generator..."
echo
sleep 5

## enable gtg modules
drush en -y galaxy_tool_generator galaxy_tool_generator_ui

##
# sh -c "$@"
## start apache
rm -f /usr/local/apache2/logs/httpd.pid
/usr/sbin/httpd -DFOREGROUND