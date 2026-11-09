FROM debian:bookworm

RUN apt-get update \
    && apt-get install -y php8.2-fpm \
    && rm -rf /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/

RUN mkdir -p /run/php

EXPOSE 9000

CMD ["php-fpm8.2", "-F"]
