#!/bin/bash
set -euo pipefail

if [[ "${WP_ADMIN_USER,,}" == *admin* ]]; then
    echo "wordpress: WP_ADMIN_USER must not contain 'admin'" >&2
    exit 1
fi

cd /var/www/html

if [ ! -f wp-includes/version.php ]; then
    echo "wordpress: copying core files into the volume"
    cp -a /usr/src/wordpress/. .
fi

if [ ! -f wp-config.php ]; then
    wp config create --allow-root \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$(< /run/secrets/db_password)" \
        --dbhost=mariadb:3306 \
        --skip-check
fi

if ! wp core is-installed --allow-root 2> /dev/null; then
    echo "wordpress: installing site and creating users"
    wp core install --allow-root \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$(< /run/secrets/wp_admin_password)" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email
    wp user create --allow-root "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$(< /run/secrets/wp_user_password)"
fi

chown -R www-data:www-data /var/www/html

exec php-fpm8.2 -F
