FROM dockerphp5329debian_php-fpm
MAINTAINER chenshiyang <chenshiyang460@emao.com>

# Install env
ENV LANG C.UTF-8
ADD sources.list /etc/apt/sources.list
RUN set -xe \
    && echo "构建依赖" \
    && buildDeps=" \
    	libmcrypt-dev \
    	libfreetype6-dev \
    	libjpeg62-turbo-dev \
    	libpng12-dev \
    	libltdl-dev \
    " \
    && echo "运行依赖" \
    && runtimeDeps=" \
        libfreetype6 \
        libjpeg62-turbo \
        libmcrypt4 \
        libpng12-0 \
    " \
    && echo "安装 php 以及编译构建组件所需包" \
    && php -m \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y ${runtimeDeps} ${buildDeps} --no-install-recommends \
    #ubuntu debian系统 freetype目录为/usr/include/freetype2/freetype/freetype.h
    && mkdir /usr/include/freetype2/freetype \
    && ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h \
    && echo "编译安装 php 组件" \
    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd mbstring zip \
    && docker-php-ext-enable gd mbstring zip \
    #&& echo "extension_dir=/usr/local/lib/php/extensions/no-debug-non-zts-20090626/pdo_mysql.so" > /usr/local/etc/php/conf.d/pdo_mysql.ini \
    #&& echo "extension=pdo_mysql.so" >> /usr/local/etc/php/conf.d/pdo_mysql.ini \
    #&& echo "extension_dir=/usr/local/lib/php/extensions/no-debug-non-zts-20090626/pdo.so" > /usr/local/etc/php/conf.d/pdo.ini  \
    #&& echo "extension=pdo.so" >> /usr/local/etc/php/conf.d/pdo.ini \
    && php -m \
    && echo "清理" \
    && apt-get purge -y --auto-remove \
        -o APT::AutoRemove::RecommendsImportant=false \
        -o APT::AutoRemove::SuggestsImportant=false \
        $buildDeps \
    && rm -rf /var/cache/apt/* \
    && rm -r /var/lib/apt/lists/* \
    && php -m
	
# Install PHP extensions
COPY redis.tgz /tmp/redis.tgz
COPY xdebug.tgz /tmp/xdebug.tgz
COPY xhprof.tgz /tmp/xhprof.tgz
COPY memcache.tgz /tmp/memcache.tgz
COPY memcached.tgz /tmp/memcached.tgz
COPY yaf.tgz /tmp/yaf.tgz
COPY imagick.tgz /tmp/imagick.tgz

RUN  mkdir -p /var/log/nginx/app && mkdir -p /var/log/php-fpm/ && mkdir -p /var/cache/nginx/

RUN chown -R nginx.nginx /var/log/php-fpm/ /var/cache/nginx/ /var/log/nginx/app

#设置时区
RUN sed -i 's@Etc/UTC@Asia/Shanghai@g' /etc/timezone

RUN  \
    echo "安装imagick扩展" \
    && apt-get update && apt-get install -y tar libmagickwand-dev libmagickcore-dev libmemcached-dev \
    && cd /tmp \
    && tar xvzf imagick.tgz -C /tmp \
    && cd imagick* \
    && phpize \
    && ./configure \
    && make install \
    && rm -rf /tmp/imagick \
    && echo 'extension=imagick.so' >> /usr/local/etc/php/conf.d/imagick.ini \
    && echo '安装yaf扩展' \
    && cd /tmp && tar zxvf yaf.tgz && cd yaf* && phpize && ./configure --with-php-config='/usr/local/bin/php-config' && make && make install \
    && echo "extension=yaf.so" > /usr/local/etc/php/conf.d/yaf.ini && echo "yaf.use_spl_autoload = 1" >> /usr/local/etc/php/conf.d/yaf.ini \
    && echo "yaf.lowcase_path = 1" >> /usr/local/etc/php/conf.d/yaf.ini && echo "yaf.st_compatible = 1" >> /usr/local/etc/php/conf.d/yaf.ini \
    && echo '安装xdebug扩展' \
    && pecl install /tmp/xdebug.tgz && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20090626/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port=9003" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo '安装redis扩展' \
    && pecl install /tmp/redis.tgz && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
    && echo '安装xhprof扩展' \
    && pecl install /tmp/xhprof.tgz && echo "extension=xhprof.so" > /usr/local/etc/php/conf.d/xhprof.ini \
    && echo '安装memcache扩展' \
    && pecl install /tmp/memcache.tgz && echo 'extension=memcache.so' > /usr/local/etc/php/conf.d/memcache.ini \
    && echo '安装memcached扩展' \
    && pecl install /tmp/memcached.tgz && echo 'extension=memcached.so' > /usr/local/etc/php/conf.d/memcached.ini \
    && rm -rf /tmp/*



# PHP config
ADD php.ini /usr/local/etc/php/php.ini

#Composer
ADD composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

WORKDIR /data/www/



#修改系统hosts文件路径，将/tmp/hosts文件映射到宿主机hosts,这是个错误方式不推荐使用
#RUN cp /etc/hosts /tmp/hosts
#RUN mkdir -p /lib-override && cp /lib/x86_64-linux-gnu/libnss_files.so.2 /lib-override
#RUN sed -i 's:/etc/hosts:/tmp/hosts:g' /lib-override/libnss_files.so.2
#ENV LD_LIBRARY_PATH /lib-override

# php-fpm:9000 xdebug:9003
EXPOSE 9003
VOLUME ["/data/www/","/var/run/", "/var/cache/nginx/"]

RUN echo '#!/bin/bash' > /init.sh && \
    echo '/usr/local/sbin/php-fpm -F' >> /init.sh && \
    chmod +x /init.sh
CMD ["/init.sh"]
RUN echo 'hahahaha done!'
