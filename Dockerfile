FROM php:5.5-fpm

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev

RUN docker-php-ext-install iconv mcrypt mysql
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd
RUN docker-php-ext-install zip
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql

RUN apt-get install -y git

# Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer

# Install php extension 
# Memcache
RUN yes '' | pecl install -f memcache
RUN echo "extension=memcache.so" >> /usr/local/etc/php/conf.d/memcache.ini

# Memcached
RUN apt-get install -y libsasl2-dev 
RUN apt-get install -y build-essential
RUN apt-get install -y wget
RUN wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
RUN tar xzf libmemcached-1.0.18.tar.gz
RUN ./libmemcached-1.0.18/configure --enable-sasl
RUN make install
RUN yes '' | pecl install -f memcached
RUN echo "extension=memcached.so" >> /usr/local/etc/php/conf.d/memcached.ini

COPY phpfpm-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/phpfpm-foreground

RUN curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/phpfpm-foreground"]