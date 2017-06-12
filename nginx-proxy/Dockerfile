FROM nginx:1.9.0

ADD nginx.conf /etc/nginx/nginx.conf
#ADD sites-enabled/* /etc/nginx/conf.d/
RUN mkdir -p /data/www/log/nginx && mkdir -p /var/log/nginx/ && mkdir -p /data/www/emao.com/trunk/
RUN chown -R nginx.nginx /data/www/emao.com/trunk/ /var/log/nginx/

#RUN cp /etc/hosts /tmp/hosts
#RUN mkdir -p /lib-override && cp /lib/x86_64-linux-gnu/libnss_files.so.2 /lib-override
#RUN sed -i 's:/etc/hosts:/tmp/hosts:g' /lib-override/libnss_files.so.2
#ENV LD_LIBRARY_PATH /lib-override

EXPOSE 80 443
VOLUME ["/data/www"]
