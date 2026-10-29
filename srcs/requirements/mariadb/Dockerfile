FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

CMD ["mariadbd", "--user=mysql"]
