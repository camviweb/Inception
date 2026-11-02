FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx

COPY nginx.conf /etc/nginx/

EXPOSE 443

CMD ["nginx", "-g", "daemon off"]
