# Use the official NGINX base image
FROM nginx:latest

# Copy custom configuration (if any) to NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# Copy website files (if any) to the NGINX default root directory
COPY www /var/www/html

COPY certs /etc/nginx/certs

# Expose ports
EXPOSE 8080
EXPOSE 8443

