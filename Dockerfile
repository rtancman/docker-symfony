FROM php:5.5-fpm

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install iconv mcrypt mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN apt-get install -y git

# Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer

# Install php extension 
# memcached
RUN yes '' | pecl install -f memcached
RUN echo "extension=memcached.so" >> /usr/local/etc/php/conf.d/memcached.ini

COPY phpfpm-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/phpfpm-foreground

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/phpfpm-foreground"]