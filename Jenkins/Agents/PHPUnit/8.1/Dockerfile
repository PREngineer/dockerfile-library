# Use the latest alpine image from PHP
FROM php:8.1.19-fpm-alpine

LABEL mantainer="Jorge Pabón <pianistapr@hotmail.com>" description="A Jenkins agent to run tests using PHPUnit 10.1.0, PHP 8.1."

# Start on the /tmp folder
WORKDIR /tmp

###################################################################################################################
# When installing packages from APK
# Do not use GIT! It will include a lot of unnecessary stuff from the repos that will make your image gigantic ~3GB
###################################################################################################################
RUN apk --no-cache add \
  ca-certificates \
  # We need composer to set up PHPUnit
  composer \
  linux-headers \
  # Add dependencies for PHP 8.1
  php81-bcmath \
  php81-calendar \
  php81-ctype \
  php81-curl \
  php81-dom \
  php81-exif \
  php81-fileinfo \
  php81-json \
  php81-mbstring \
  php81-mysqli \
  php81-opcache \
  php81-openssl \
  php81-pcntl \
  php81-pdo \
  php81-pdo_dblib \
  php81-pdo_mysql \
  php81-pdo_odbc \
  php81-pdo_pgsql \
  php81-pdo_sqlite \
  php81-pecl-memcache \
  php81-phar \
  php81-session \
  php81-simplexml \
  php81-soap \
  php81-tokenizer \
  php81-xdebug \
  php81-xml \
  php81-xmlreader \
  php81-xmlwriter \
  php81-zip \
  php81-zlib \
  # We also use PEAR
  && php -r "copy('https://pear.php.net/go-pear.phar', 'go-pear.phar');" \
  && php go-pear.phar \
  && php -r "unlink('go-pear.phar');"

# Install PHPUnit 10.5.0 using composer
RUN composer require "phpunit/phpunit:10.5.0" --prefer-source --no-interaction \
&& composer require "phpunit/php-invoker" --prefer-source --no-interaction \
# Install into /usr/local/bin/phpunit
&& ln -s /tmp/vendor/bin/phpunit /usr/local/bin/phpunit \
# Add name to PHPUnit providers
&& sed -i 's/nn and/nn, Jorge Pabón, and/g' /tmp/vendor/phpunit/phpunit/src/Runner/Version.php

# Install X-Debug
RUN apk --no-cache add pcre-dev ${PHPIZE_DEPS} \ 
&& pecl install xdebug \
&& docker-php-ext-enable xdebug \
&& apk del pcre-dev ${PHPIZE_DEPS} \
# Configure X-Debug
&& echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.mode=coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.log=/App/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.discover_client_host=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.client_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Switch to the /App directory
WORKDIR /App

# Start the container with the linux shell
ENTRYPOINT ["/bin/sh"]

# How to build for single architecture:
# docker login -u <USERNAME> -p <PAT>
# docker build -t prengineer/jenkins-php-agent:8.1 . -f Dockerfile

# How to build for multi architecture:
# docker login -u <USERNAME> -p <PAT>
# docker buildx build --push --platform=linux/amd64,linux/arm64 -t prengineer/jenkins-php-agent:8.1 -f Dockerfile .