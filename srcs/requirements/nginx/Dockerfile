FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx

COPY nginx.conf /etc/nginx/

CMD ["nginx", "-g", "daemon off"]
