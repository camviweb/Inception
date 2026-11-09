FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

COPY conf/90-inception.cnf /etc/mysql/mariadb.conf.d/

COPY tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT ["init.sh"]
