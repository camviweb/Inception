FROM debian:bookworm

RUN apt-get update \
    && apt-get install -y nginx openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 \
    -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key \
    -subj "/CN=canguyen.42.fr"

COPY nginx.conf /etc/nginx/

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
