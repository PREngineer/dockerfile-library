#!/bin/sh

echo "-> Starting PHP-FPM ... ";
php-fpm7

echo "-> Starting NginX ... ";
nginx -g "daemon off;"