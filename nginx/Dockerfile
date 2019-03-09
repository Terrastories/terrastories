FROM nginx:latest

RUN apt-get update && apt-get install -y wget

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

ADD nginx.conf.template /etc/nginx

CMD dockerize -template /etc/nginx/nginx.conf.template:/etc/nginx/nginx.conf \
              -wait tcp://rails:3000 \
              nginx -g 'daemon off;'
