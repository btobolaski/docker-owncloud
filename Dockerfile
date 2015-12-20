FROM phusion/baseimage:latest
MAINTAINER Brendan Tobolaski "brendan@tobolaski.com"
ENV OC_VERSION 8.2.1
RUN apt-get -y update
RUN apt-get install -y apache2 php5 php5-gd php-xml-parser php5-intl php5-mysqlnd php5-json php5-mcrypt smbclient curl libcurl3 php5-curl bzip2 wget
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN curl -k https://download.owncloud.org/community/owncloud-$OC_VERSION.tar.bz2 | tar jx -C /var/www/
RUN mkdir /var/www/owncloud/data
RUN chown -R www-data:www-data /var/www/owncloud

ADD ./001-owncloud.conf /etc/apache2/sites-available/
RUN rm -f /etc/apache2/sites-enabled/000*
RUN ln -s /etc/apache2/sites-available/001-owncloud.conf /etc/apache2/sites-enabled/
RUN a2enmod rewrite

ADD rc.local /etc/rc.local
RUN chown root:root /etc/rc.local

VOLUME ["/var/www/owncloud/data", "/var/www/owncloud/config"]
EXPOSE 80
CMD ["/sbin/my_init"]
