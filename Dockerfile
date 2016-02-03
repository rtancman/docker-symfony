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

RUN apt-get update && apt-get install -y \
        libxml2-dev

RUN docker-php-ext-install soap
RUN docker-php-ext-install shmop
RUN docker-php-ext-install sockets
RUN docker-php-ext-install sysvmsg
RUN docker-php-ext-install sysvsem
RUN docker-php-ext-install sysvshm
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install gettext
RUN docker-php-ext-install exif
RUN docker-php-ext-install dba
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install calendar
RUN apt-get install -y libbz2-dev
RUN docker-php-ext-install bz2
RUN docker-php-ext-configure wddx
RUN docker-php-ext-install wddx
RUN docker-php-ext-install mysqli

RUN yes '' | pecl install -f apcu
RUN echo "extension=apcu.so" >> /usr/local/etc/php/conf.d/apcu.ini

# Xdebug
RUN yes '' | pecl install -f xdebug
RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20121212/xdebug.so \n\
xdebug.remote_enable=1 \n\
xdebug.remote_handler=dbgp \n\
xdebug.remote_autostart=0 \n\
xdebug.remote_connect_back=0 \n\
xdebug.remote_log=\"/var/log/xdebug.log\"" >> /usr/local/etc/php/conf.d/xdebug.ini

# zendopcache
# RUN yes '' | pecl install -f zendopcache-7.0.2
# RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20121212/opcache.so \n\
# opcache.memory_consumption=128  \n\
# opcache.interned_strings_buffer=8  \n\
# opcache.max_accelerated_files=4000  \n\
# opcache.revalidate_freq=60  \n\
# opcache.fast_shutdown=1  \n\
# opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/opcache.ini

RUN wget psysh.org/psysh
RUN chmod +x psysh
RUN mv ./psysh /usr/bin/psysh

WORKDIR /var/www/html

EXPOSE 9004
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/phpfpm-foreground"]