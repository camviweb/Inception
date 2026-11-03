#!/bin/bash
set -e

mariadb --user=mysql &
pid=$!

mariadb << EOF
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wduser'@'%' IDENTIFIED BY mdp;
EOF
