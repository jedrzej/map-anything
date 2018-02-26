FROM php:7.1-apache

MAINTAINER Jędrzej Kuryło <jedrzej.kurylo@gmail.com>

ADD . /var/www
ADD ./public /var/www/html
ADD php.ini /usr/local/etc/php/

# install dependencies
RUN apt-get update && apt-get install -y git zlib1g-dev mysql-client libmcrypt-dev

# install and enable mbstring, zip and pcntl extensions
RUN docker-php-ext-install mbstring pcntl opcache pdo_mysql mysqli mcrypt zip

RUN a2enmod rewrite

# install composer
RUN curl -sS https://getcomposer.org/installer | php && chmod a+x composer.phar && mv composer.phar /usr/bin/composer

# configure apache
RUN usermod -u 1000 www-data
RUN mkdir -p /var/www/storage/app /var/www/storage/framework /var/www/storage/logs
RUN chown -R www-data:www-data /var/www/storage/app /var/www/storage/framework /var/www/storage/logs

# configure environment variables
ENV COMPOSER_PROCESS_TIMEOUT=900

WORKDIR /var/www
