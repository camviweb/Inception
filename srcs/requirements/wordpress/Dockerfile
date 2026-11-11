FROM debian:bookworm

ARG WP_CLI_VERSION=2.12.0
ARG WP_VERSION=7.1.4

RUN apt-get update \
    && apt-get install -y php8.2-fpm php8.2-cli php8.2-mysql \
        php8.2-curl php8.2-mbstring php8.2-xml php8.2-gd \
        curl mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o /usr/local/bin/wp "https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar" \
    && chmod +x /usr/local/bin/wp \
    && wp core download --path=/usr/src/wordpress --version=${WP_VERSION} --allow-root \
    && chown -R www-data:www-data /usr/src/wordpress

RUN mkdir -p /run/php

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/

COPY tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["init.sh"]
