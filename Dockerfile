FROM ubuntu:trusty
MAINTAINER ClassCat Co.,Ltd. <support@classcat.com>

########################################################################
# ClassCat/OwnCloud Dockerfile
#   Maintained by ClassCat Co.,Ltd ( http://www.classcat.com/ )
########################################################################

#--- HISTORY -----------------------------------------------------------
# 28-may-15 : 8.0.3 and php5-common, which includes php5enmod.
# 23-may-15 : quay.io.
# 19-may-15 : trusty.
# 17-may-15 : sed -i.bak
# 16-may-15 : php5-gd php5-json php5-curl php5-imagick libapache2-mod-php5.
# 08-may-15 : Created.
#-----------------------------------------------------------------------

RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y language-pack-en language-pack-en-base \
  && apt-get install -y language-pack-ja language-pack-ja-base \
  && update-locale LANG="en_US.UTF-8" \
  && apt-get install -y openssh-server supervisor rsyslog mysql-client \
    apache2 php5 php5-commoon php5-mysql php5-mcrypt php5-intl \
    php5-gd php5-json php5-curl php5-imagick libapache2-mod-php5 \
  && mkdir -p /var/run/sshd \
  && sed -i.bak -e "s/^PermitRootLogin\s*.*$/PermitRootLogin yes/" /etc/ssh/sshd_config
# RUN sed -i -e 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

COPY assets/supervisord.conf /etc/supervisor/supervisord.conf

RUN php5enmod mcrypt \
&& sed -i.bak -e "s/^;date\.timezone =.*$/date\.timezone = 'Asia\/Tokyo'/" /etc/php5/apache2/php.ini \
&& sed -i     -e "s/^;default_charset =.*$/default_charset = \"UTF-8\"/"   /etc/php5/apache2/php.ini

WORKDIR /usr/local
RUN apt-get install -y bzip2 \
  && apt-get clean \
  && wget https://download.owncloud.org/community/owncloud-8.0.3.tar.bz2 \
  && tar xfj owncloud-8.0.3.tar.bz2 \
  && mv /var/www/html /var/www/html.orig \
  && cp -r owncloud /var/www/html \
  && chown -R www-data.www-data /var/www/html/config \
  && chown -R www-data.www-data /var/www/html/apps \
  && a2enmod ssl \
  && a2ensite default-ssl \
  && sed -i.bak2 -e "s/^;always_populate_raw_post_data =.*$/always_populate_raw_post_data = -1/" /etc/php5/apache2/php.ini

WORKDIR /opt
COPY assets/cc-init.sh /opt/cc-init.sh

EXPOSE 22 80 443

CMD /opt/cc-init.sh; /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
