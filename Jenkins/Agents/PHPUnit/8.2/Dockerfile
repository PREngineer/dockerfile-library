# Use the latest alpine image from PHP
FROM php:8.2.18-fpm-alpine

LABEL mantainer="Jorge Pabón <pianistapr@hotmail.com>" description="A Jenkins agent to run tests using PHPUnit 11.1.0, PHP 8.2."

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
  # Add dependencies for PHP 8.2
  php82-bcmath \
  php82-calendar \
  php82-ctype \
  php82-curl \
  php82-dom \
  php82-exif \
  php82-fileinfo \
  php82-json \
  php82-mbstring \
  php82-mysqli \
  php82-opcache \
  php82-openssl \
  php82-pcntl \
  php82-pdo \
  php82-pdo_dblib \
  php82-pdo_mysql \
  php82-pdo_odbc \
  php82-pdo_pgsql \
  php82-pdo_sqlite \
  php82-pecl-memcache \
  php82-phar \
  php82-session \
  php82-simplexml \
  php82-soap \
  php82-tokenizer \
  php82-xdebug \
  php82-xml \
  php82-xmlreader \
  php82-xmlwriter \
  php82-zip \
  php82-zlib \
  # We also use PEAR
  && php -r "copy('https://pear.php.net/go-pear.phar', 'go-pear.phar');" \
  && php go-pear.phar \
  && php -r "unlink('go-pear.phar');"

# Install PHPUnit 11.1.0 using composer
RUN composer require "phpunit/phpunit:11.1.0" --prefer-source --no-interaction \
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
# docker build -t prengineer/jenkins-php-agent:8.2 . -f Dockerfile

# How to build for multi architecture:
# docker buildx build --push --platform=linux/amd64,linux/arm64 -t prengineer/jenkins-php-agent:8.2 -f Dockerfile .