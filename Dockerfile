FROM ubuntu:14.04

MAINTAINER Oransel <oransel@yahoo.com>

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

# Add image scripts
ADD ./scripts/start-apache2.sh /start-apache2.sh
ADD ./scripts/start-spotweb-update.sh /start-spotweb-update.sh
ADD ./scripts/start-mysqld.sh /start-mysqld.sh
ADD ./scripts/create_mysql.sh /create_mysql.sh
ADD ./scripts/entrypoint.sh /entrypoint.sh
RUN chmod 755 /*.sh

# Add image configurations
ADD ./configs/cron.conf /cron.conf
ADD ./configs/apache-config.conf /etc/apache2/sites-enabled/000-default.conf
ADD ./configs/my.cnf /etc/mysql/conf.d/my.cnf
ADD ./configs/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD ./configs/supervisord-spotweb.conf /etc/supervisor/conf.d/supervisord-spotweb.conf
ADD ./configs/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# Install packages
RUN apt-get update && \
    apt-get -y install apache2 php5 php5-curl php5-gd php5-gmp php5-mysql php-apc php5-mcrypt libapache2-mod-php5 git mysql-server supervisor pwgen && \

# Enable apache mods
    a2enmod php5 && \

# Create apache directories
    mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

# Remove pre-installed database
    rm -rf /var/lib/mysql/*

# clean extra packages
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Download latest spotweb source
RUN git clone https://github.com/Spotweb/Spotweb.git /var/www/spotweb

# Add volumes for MySQL 
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD []

