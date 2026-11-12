#!/bin/bash
set -e

if [ ! -f wp-config.php ]; then
    cp -a /usr/src/wordpress/. .

    until mariadb-admin ping -h mariadb -u"$MYSQL_USER" -p"$(< /run/secrets/db_user_password)" --silent; do
        sleep 1
    done

    wp config create --allow-root \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$(< /run/secrets/db_user_password)" \
        --dbhost=mariadb

    wp core install --allow-root \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$(< /run/secrets/wp_admin_password)" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email
    
    wp user create --allow-root "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$(< /run/secrets/wp_user_password)" --role=author

    chown -R www-data:www-data /var/www/html
fi

exec php-fpm8.2 -F
