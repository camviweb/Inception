#!/bin/bash
set -euo pipefail

DATADIR=/var/lib/mysql

chown -R mysql:mysql "$DATADIR" /run/mysqld

if [ ! -d "$DATADIR/mysql" ]; then
    echo "mariadb: creating system tables"
    mariadb-install-db --user=mysql --datadir="$DATADIR" --skip-test-db > /dev/null
fi

if [ ! -d "$DATADIR/$MYSQL_DATABASE" ]; then
    echo "mariadb: creating database $MYSQL_DATABASE and user $MYSQL_USER"
    mariadbd --user=mysql --bootstrap <<SQL
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(< /run/secrets/db_root_password)';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '$(< /run/secrets/db_password)';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
SQL
fi

exec mariadbd --user=mysql
