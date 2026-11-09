# FROM debian:bookworm

# RUN apt-get update \
    && apt-get install -y --no-install-recommends mariadb-server \
    # && rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/lib/mysql \
    && mkdir -p /var/lib/mysql /run/mysqld \
    && chown mysql:mysql /var/lib/mysql /run/mysqld

# COPY conf/90-inception.cnf /etc/mysql/mariadb.conf.d/90-inception.cnf
# COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh

# EXPOSE 3306

# ENTRYPOINT ["entrypoint.sh"]
