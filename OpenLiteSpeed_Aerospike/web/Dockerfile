FROM ubuntu:16.04 
ENV PATH /usr/local/lsws/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin 
RUN apt-get update && apt-get upgrade -y && apt-get install -y wget pv pigz
RUN cd /root && wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debain_repo.sh | bash
RUN apt-get update && apt-get install -y openlitespeed
RUN apt-get install -y lsphp72 lsphp72-common lsphp72-mysql lsphp72-json lsphp72-dev lsphp72-curl

RUN ln -s /usr/local/lsws/lsphp72/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp7
RUN update-alternatives --install /usr/bin/php php /usr/local/lsws/lsphp72/bin/php7.2 72
RUN update-alternatives --install /usr/bin/phpize phpize /usr/local/lsws/lsphp72/bin/phpize7.2 72
RUN update-alternatives --install /usr/bin/php-config php-config /usr/local/lsws/lsphp72/bin/php-config7.2 72
# Disable Zend Opcache extension
RUN cd /usr/local/lsws/lsphp72/etc/php/7.2/mods-available/ && mv opcache.ini opcache.ini.disabled

# Build and install Aerospike extension
RUN apt-get install build-essential libssl-dev
RUN cd /root && wget https://github.com/aerospike/aerospike-client-php/archive/7.1.2.tar.gz -O aerospike-client-php-7.1.2.tar.gz
RUN cd /root && tar xzf aerospike-client-php-7.1.2.tar.gz
RUN cd /root/aerospike-client-php-7.1.2/src && ./build.sh && make install
RUN mkdir -p /usr/local/lsws/lsphp72/share/lsphp72-aerospike/aerospike
COPY ./aerospike.ini /usr/local/lsws/lsphp72/share/lsphp72-aerospike/aerospike
RUN cd /usr/local/lsws/lsphp72/etc/php/7.2/mods-available/ && ln -s ../../../../share/lsphp72-aerospike/aerospike/aerospike.ini

# Clean up unused files
RUN rm -rf /usr/local/lsws/conf/httpd_config.conf /var/lib/apt/lists/* && apt-get remove --purge -y wget
RUN rm -rf /root/aerospike-client-php-7.1.2.tar.gz /root/aerospike-client-php-7.1.2/

VOLUME ["/usr/local/lsws/conf"]

EXPOSE 80 7080

ENTRYPOINT ["openlitespeed", "-n"]
