#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    mariadbd --user=mysql &
    pid=$!

    until mariadb-admin ping --silent; do
        sleep 1
    done

    mariadb << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '$(< /run/secrets/db_user_password)';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(< /run/secrets/db_root_password)';
FLUSH PRIVILEGES;
EOF

    mariadb-admin -u root -p"$(< /run/secrets/db_root_password)" shutdown
    wait $pid
fi

exec mariadbd --user=mysql
