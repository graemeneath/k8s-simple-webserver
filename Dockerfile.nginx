# Use the official Nginx image as the base
#FROM nginx:latest

#COPY certs /etc

# Copy Nginx configuration
#COPY nginx.conf /etc/nginx/nginx.conf

# Expose HTTP and HTTPS ports
#EXPOSE 80 443


FROM ubuntu

RUN apt-get update
RUN apt-get install -y nginx

EXPOSE 8080 8443

COPY certs /etc
COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
