user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log debug;

events {
    worker_connections  1024;
}

http {
  server {
    listen 80;
    
    location / {
      # React routes are entirely on the App side in the web browser
      # Always proxy to root with the same page request when nginx 404s
      error_page 404 /;
      proxy_intercept_errors on;
      proxy_set_header Host ${VAR_PREFIX}host;
      proxy_pass http://${FRONTEND_NAME}:3000/;
    }
    location ~ ^/(api|media)/ {
      proxy_set_header X-Forwarded-Proto ${VAR_PREFIX}scheme;
      proxy_set_header X-Real-IP ${VAR_PREFIX}remote_addr;
      proxy_set_header Host ${BACKEND_NAME};
      include uwsgi_params;
      proxy_pass http://${BACKEND_NAME}:8001;
    }
    # needed for webpack-dev-server
    location /ws {
      proxy_pass http://${FRONTEND_NAME}:3000;
      proxy_http_version 1.1;
      proxy_set_header Upgrade ${VAR_PREFIX}http_upgrade;
      proxy_set_header Connection "upgrade";
    }
    # Django media
    location /protected_media  {
        internal;
        alias /protected_media/;      
    }

    location /static/drf-yasg {
        proxy_pass http://${BACKEND_NAME}:8001;
    }

    location /data  {
        internal;
        alias /data/;      
    }

    # Original Photos
    location /original  {
        internal;
        alias /data/;
    }
    # Nextcloud Original Photos
    location /nextcloud_original  {
        internal;
        alias /data/nextcloud_media/;
    }
  }
}