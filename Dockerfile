# Galaxy Tool Generator
#
# Version 1.0
FROM centos:7

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
ENV GTG_PG_USER=gtg \
    GTG_PG_DB=gtg_db \
    GTG_PG_PASSWD=gtg_passwd
RUN yum install -y postgresql-server
USER postgres

RUN initdb --encoding=UTF8 -D /var/lib/pgsql/data/
ADD postgresql/* /var/lib/pgsql/data/
RUN pg_ctl start -D /var/lib/pgsql/data/ && sleep 5 && \
    psql -c "CREATE USER ${GTG_PG_USER} WITH PASSWORD '${GTG_PG_PASSWD}';" && \
    createdb --encoding=UTF8 ${GTG_PG_DB} -O ${GTG_PG_USER}
##=========================================


##========= Drush =========================
USER root
RUN yum install -y drush
# RUN php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush && \
#     chmod +x drush && \
#     mv drush /usr/local/bin && \
#     yes | drush init
##=========================================

##========= Drupal ========================
## Install drupal
##=========================================
ENV DRUPAL_ADMIN=galaxy \
    DRUPAL_PASSWD=galaxy
ADD apache/httpd.conf /etc/httpd/conf/httpd.conf
WORKDIR /var/www/html
RUN rm -rf /var/lib/pgsql/data/postmaster.pid && \
	sudo -u postgres pg_ctl start -D /var/lib/pgsql/data/ && sleep 30 && \
	drush dl drupal-7.56 -y && \
    mv drupal*/* ./ && \
    mv drupal*/.htaccess ./ && \
    rm -rf drupal-7.56 && \
    cp sites/default/default.settings.php sites/default/settings.php && \
    chmod 777 sites/default/settings.php && \
    mkdir sites/default/files && chown -R apache:apache sites/default/files/ && \
    yum install sendmail -y && \
    yes | drush site-install --site-name="Galaxy Tool Generator"  --db-url=pgsql://${GTG_PG_USER}:${GTG_PG_PASSWD}@localhost/${GTG_PG_DB} --account-name=${DRUPAL_ADMIN} --account-pass=${DRUPAL_PASSWD} -y

## add debugging lines to settings.php
RUN chmod +w sites/default/settings.php && \
    echo '$conf["drupal_http_request_fails"] = FALSE;' >> sites/default/settings.php && \
    echo '$conf["theme_debug"] = TRUE;' >> sites/default/settings.php && \
    echo 'error_reporting(-1);' >> sites/default/settings.php && \
    echo '$conf["error_level"] = 2;' >> sites/default/settings.php && \
    echo 'ini_set("display_errors", TRUE);' >> sites/default/settings.php && \
    echo 'ini_set("display_startup_errors", TRUE);' >> sites/default/settings.php
##===========================================


##==================Install planemo===========
##
##============================================
RUN yum -y update && \
    # fix error: 'command 'gcc' failed with exit status 1' \
    yum -y install gcc gcc-c++ kernel-devel && \
    yum -y install python-devel libxslt-devel libffi-devel openssl-devel && \
	yum -y install python-pip && \
	pip install --upgrade setuptools && \
	pip install planemo

## Install php extension to handle yaml file	
RUN yum install -y php-yaml tree

## allow exec() function to run planemo as sudoer (https://exain.wordpress.com/2007/11/24/execute-system-commands-via-php/).
RUN echo 'apache ALL=NOPASSWD: ALL' >> /etc/sudoers


##=================Install drupal modules=====
##
##============================================
WORKDIR /var/www/html/sites/all/modules
RUN mkdir -p /var/www/html/sites/default/files/galaxy_tool_repository
RUN rm -rf /var/lib/pgsql/data/postmaster.pid && \
    sudo -u postgres pg_ctl start -D /var/lib/pgsql/data/ && sleep 30 && \
    rm -f /usr/local/apache2/logs/httpd.pid && \
    /usr/sbin/httpd && sleep 5 && \
    drush en devel admin_menu token page_load_progress -y && \
    drush dis toolbar -y && \
    mkdir GTG_modules && cd GTG_modules && \
    yum install -y git && \
    git clone https://github.com/MingChen0919/galaxy_tool_generator.git && \
    git clone https://github.com/MingChen0919/galaxy_tool_generator_ui.git && \
    drush en -y galaxy_tool_generator galaxy_tool_generator_ui


## Install conda with planemo
RUN yum -y install bzip2 && planemo conda_init

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]