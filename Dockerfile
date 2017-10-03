# Galaxy Tool Generator
#
# Version 1.0
FROM centos:latest

##======== Development tools =============
## Includes:
##		- Development tools
##========================================
RUN yum install -y initscripts sudo which wget
##========================================

##======== Apache ========================
RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install httpd && \
    yum clean all
##========================================

##======= Install php5.6 =================
## Includes:
##		- install default php5.4
##		- upgrade php5.4 to php5.6
##		- install other required php extensions
##========================================
RUN yum install -y php && \
    cd /tmp && wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm -Uvh epel-release-latest-7.noarch.rpm && \
    wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    rpm -Uvh remi-release-7.rpm

## Upgrade php from default 5.4 to 5.6
ADD php5.6/remi.repo /etc/yum.repos.d/remi.repo
RUN yum upgrade -y php* && \
    yum install -y php-gd php-pgsql php-mbstring php-xml php-pecl-json
##========================================


##=========== Postgresql =================
## Includes:
##		- install postgresql-server
##		- initiate database
##		- create database and database user
##========================================
ENV GALAXY_TOOL_PG_USER=galaxy_tool_generator \
    GALAXY_TOOL_PG_DB=galaxy_tool_generator_db \
    GALAXY_TOOL_PG_PASSWD=galaxy_tool_generator_passwd
RUN yum install -y postgresql-server
USER postgres

RUN initdb --encoding=UTF8 -D /var/lib/pgsql/data/
ADD postgresql/* /var/lib/pgsql/data/
RUN pg_ctl start -D /var/lib/pgsql/data/ && sleep 5 && \
    psql -c "CREATE USER ${GALAXY_TOOL_PG_USER} WITH PASSWORD '${GALAXY_TOOL_PG_PASSWD}';" && \
    createdb --encoding=UTF8 ${GALAXY_TOOL_PG_DB} -O ${GALAXY_TOOL_PG_USER}
##=========================================


##========= Drush =========================
USER root
RUN php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush && \
    chmod +x drush && \
    mv drush /usr/local/bin && \
    yes | drush init
##=========================================

##========= Drupal ========================
## Install drupal
##=========================================
ENV DRUPAL_ADMIN=galaxy \
    DRUPAL_PASSWD=galaxy
ADD apache/httpd.conf /etc/httpd/conf/httpd.conf
ADD drupal/settings.php /tmp/settings.php
WORKDIR /var/www/html
RUN rm -rf /var/lib/pgsql/data/postmaster.pid && \
	sudo -u postgres pg_ctl start -D /var/lib/pgsql/data/ && sleep 30 && \
	drush dl drupal-7.56 -y && \
    mv drupal*/* ./ && \
    mv drupal*/.htaccess ./ && \
    rm -rf drupal-7.56 && \
    cp /tmp/settings.php sites/default/settings.php && \
    chmod 777 sites/default/settings.php && \
    mkdir sites/default/files && chown -R apache:apache sites/default/files/ && \
    yum install sendmail -y && \
    yes | drush site-install --site-name="Galaxy Tool Generator"  --db-url=pgsql://${GALAXY_TOOL_PG_USER}:${GALAXY_TOOL_PG_PASSWD}@localhost/${GALAXY_TOOL_PG_DB} --account-name=${DRUPAL_ADMIN} --account-pass=${DRUPAL_PASSWD} -y
##===========================================

##=================Install drupal modules=====
##
##============================================
WORKDIR /var/www/html/sites/all/modules
RUN rm -rf /var/lib/pgsql/data/postmaster.pid && \
    sudo -u postgres pg_ctl start -D /var/lib/pgsql/data/ && sleep 30 && \
    rm -f /usr/local/apache2/logs/httpd.pid && \
    /usr/sbin/httpd && sleep 5 && \
    drush en devel admin_menu -y && \
    drush dis toolbar -y && \
    mkdir custom && cd custom && \
    yum install -y git

##==================Install planemo===========
##
##============================================
RUN yum -y update && \
	yum -y install python-pip && \
	pip install --upgrade setuptools && \
	pip install planemo


ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]