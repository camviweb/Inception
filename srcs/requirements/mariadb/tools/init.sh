#!/bin/bash
set -e

mariadbd --user=mysql &
pid=$!

until mariadb-admin ping --silent; do
    sleep 1
done

mariadb << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY 'mdp';
EOF

mariadb-admin shutdown
wait $pid

exec mariadbd --user=mysql
