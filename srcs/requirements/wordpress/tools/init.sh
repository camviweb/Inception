#!/bin/bash
set -e

if [ ! -f /var/www/html/wp-config.php ]; then
    cp -a /usr/src/wordpress/. /var/www/html/
    # until mariadb-admin ping -h mariadb --silent; do
    #     sleep 1
    # done
fi

exec php-fpm8.2 -F
