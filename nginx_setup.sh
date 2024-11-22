
#============================================
# nginx
sudo mkdir nginx-docker-compose && cd nginx-docker-compose

sudo touch docker-compose.yml

# --- docker-compose.yml
services:
  nginx:
    image: nginx:latest
    container_name: nginx-server
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html
      - /var/log/nginx:/var/log/nginx
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    restart: unless-stopped


# nginx.conf
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    server {
        listen 80;
        server_name localhost;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }

        # Enable gzip compression
        gzip on;
        gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    }
}