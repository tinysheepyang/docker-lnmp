FROM nginx:1.9.0

ENV LANG C.UTF-8
ADD sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
            git  vim curl \
            && rm -r /var/lib/apt/lists/*

ADD config/* /etc/nginx/
#ADD sites-enabled/* /etc/nginx/conf.d/
RUN mkdir -p /data/www/ && mkdir -p /var/log/nginx/app && mkdir -p /var/cache/nginx/webcache/ && mkdir -p /data/pubdirs
RUN chown -R nginx.nginx /data/www/ /var/log/nginx/app /var/cache/nginx /data/pubdirs

RUN sed -i 's@Etc/UTC@Asia/Shanghai@g' /etc/timezone


EXPOSE 8081 443
VOLUME ["/data/www", "/var/run/", "/var/cache/nginx/","/data/pubdirs"]
