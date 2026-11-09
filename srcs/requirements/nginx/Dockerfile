FROM debian:bookworm

ARG DOMAIN_NAME

RUN apt-get update \
    && apt-get install -y nginx openssl curl \
    && rm -rf /var/lib/apt/lists/*

RUN openssl req -x509 -nodes -days 365 \
    -out /etc/ssl/certs/inception.crt \
    -keyout /etc/ssl/private/inception.key \
    -subj "/CN=${DOMAIN_NAME}"

COPY conf/nginx.conf /etc/nginx/

RUN sed -i "s/_DOMAIN_NAME_/${DOMAIN_NAME}/" /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
