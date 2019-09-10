FROM nginx:latest
CMD /bin/bash -c "envsubst '\$NGINX_PORT' < /etc/nginx/nginx.conf.template \
  > /etc/nginx/nginx.conf && nginx -g 'daemon off;'
