FROM ubuntu:12.04
MAINTAINER Brendan Tobolaski "brendan@tobolaski.com"
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" >> /etc/apt/sources.list
RUN apt-get -y update

RUN dpkg-divert --local --rename --add /sbin/initctl

RUN apt-get install -y apache2 php5 php5-gd php-xml-parser php5-intl php5-mysqlnd php5-json php5-mcrypt smbclient curl libcurl3 php5-curl bzip2 wget

RUN curl http://download.owncloud.org/community/owncloud-6.0.2.tar.bz2 | tar jx -C /var/www/
RUN chown -R www-data:www-data /var/www/owncloud

ADD ./001-owncloud.conf /etc/apache2/sites-available/
RUN rm -f /etc/apache2/sites-enabled/000*
RUN ln -s /etc/apache2/sites-available/001-owncloud.conf /etc/apache2/sites-enabled/
RUN a2enmod rewrite

VOLUME ["/var/www/owncloud/data"]
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D",  "FOREGROUND"]
