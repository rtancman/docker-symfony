FROM debian:jessie

RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
RUN echo deb http://dl.hhvm.com/debian jessie main | tee /etc/apt/sources.list.d/hhvm.list

RUN apt-get clean && \
    apt-get update && \
    apt-get install -y libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2-dev \
        libsasl2-dev \
        libbz2-dev \
        libedit2 \
        libsqlite3-0 \
        libxml2 \
        autoconf \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkg-config \
        re2c \
        curl \
        wget \
        build-essential \
        git \
        gettext \
        hhvm \
        mysql-client libmysqlclient-dev \
        postgresql-client libpq-dev \
        sqlite3 libsqlite3-dev

COPY php.ini /etc/hhvm/php.ini
RUN chmod +x /etc/hhvm/php.ini

COPY server.ini /etc/hhvm/server.ini
RUN chmod +x /etc/hhvm/server.ini

# composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer

# psysh console php
RUN wget psysh.org/psysh
RUN chmod +x psysh
RUN mv ./psysh /usr/bin/psysh

# phpunit
RUN wget https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit

# symfony cli
RUN curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

# entrypoint file
COPY phpfpm-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/phpfpm-foreground

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

EXPOSE 9004
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/phpfpm-foreground"]