FROM ubuntu

RUN apt-get update
RUN apt-get install -y nginx

COPY content /var/www/html

CMD ["nginx", "-g", "daemon off;"]
