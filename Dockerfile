# Use the official NGINX base image
FROM nginx:latest

WORKDIR /etc/nginx

# Copy custom configuration (if any) to NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports
EXPOSE 80
