FROM php:5.6-fpm

# Install env
ENV LANG C.UTF-8
ADD sources.list /etc/apt/sources.list

# Install PHP extensions
COPY redis.tgz /tmp/redis.tgz
COPY xdebug.tgz /tmp/xdebug.tgz
COPY xhprof.tgz /tmp/xhprof.tgz
COPY memcache.tgz /tmp/memcache.tgz
COPY memcached.tgz /tmp/memcached.tgz
COPY yaf.tgz /tmp/yaf.tgz
COPY imagick.tgz /tmp/imagick.tgz

RUN set -xe \
    && echo "构建依赖" \
    && buildDeps=" \
    	libmcrypt-dev \
    	libfreetype6-dev \
    	libjpeg62-turbo-dev \
    	libpng12-dev \
    " \
    && echo "运行依赖" \
    && runtimeDeps=" \
	libmcrypt-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
	libmemcached-dev \
    " \
    && echo "安装 php 以及编译构建组件所需包" \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y ${runtimeDeps} ${buildDeps} --no-install-recommends \
    && echo "编译安装 php 组件" \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install zip gd mbstring mcrypt mysql mysqli pdo_mysql \
    && pecl install /tmp/redis.tgz && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
    && pecl install /tmp/memcache.tgz && echo 'extension=memcache.so' > /usr/local/etc/php/conf.d/memcache.ini \
    && pecl install /tmp/xhprof.tgz && echo "extension=xhprof.so" > /usr/local/etc/php/conf.d/xhprof.ini \
    && pecl install /tmp/xdebug.tgz && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port=9006" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && pecl install /tmp/memcached.tgz && echo 'extension=memcached.so' > /usr/local/etc/php/conf.d/memcached.ini \
    && echo "清理" \
    && apt-get purge -y --auto-remove \
        -o APT::AutoRemove::RecommendsImportant=false \
        -o APT::AutoRemove::SuggestsImportant=false \
        $buildDeps \
    && rm -rf /var/cache/apt/* \
    && rm -r /var/lib/apt/lists/* 

	

RUN sed -i 's@Etc/UTC@Asia/Shanghai@g' /etc/timezone



RUN set -xe \
    && echo "构建依赖" \
    && buildDeps=" \
	tar \
	" \
    && runtimeDeps=" \
        libmagickwand-dev \
        libmagickcore-dev \
    " \
    && apt-get update \
    && apt-get install -y ${buildDeps} ${runtimeDeps} --no-install-recommends \
    && cd /tmp \
    && tar xvzf imagick.tgz -C /tmp\
    && cd imagick* \
    && phpize \
    && ./configure \
    && make install \
    && echo 'extension=imagick.so' >> /usr/local/etc/php/conf.d/imagick.ini \
    && php -m \
    && cd /tmp && tar zxvf yaf.tgz && cd yaf* \
    && phpize \
    && ./configure --with-php-config='/usr/local/bin/php-config' \
    && make && make install \
    && echo "extension=yaf.so" > /usr/local/etc/php/conf.d/yaf.ini \
    && echo "yaf.use_spl_autoload = 1" >> /usr/local/etc/php/conf.d/yaf.ini \
    && echo "yaf.lowcase_path = 1" >> /usr/local/etc/php/conf.d/yaf.ini \
    && echo "yaf.st_compatible = 1" >> /usr/local/etc/php/conf.d/yaf.ini \
    && echo "清理" \
    && apt-get purge -y --auto-remove \
        -o APT::AutoRemove::RecommendsImportant=false \
        -o APT::AutoRemove::SuggestsImportant=false \
#        $buildDeps \
    && rm -rf /var/cache/apt/* \
    && rm -r /var/lib/apt/lists/* \
    && rm -rf /tmp/*


# PHP config
ADD php.ini /usr/local/etc/php/php.ini
ADD php-fpm.conf /usr/local/etc/php-fpm.conf

#Composer
ADD composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

WORKDIR /data/www/


# Write Permission
RUN groupadd nginx && useradd nginx -g nginx -s /sbin/nologin -M 
RUN mkdir -p /var/cache/nginx && chown -R nginx.nginx /var/cache/nginx

# xdebug:9006
EXPOSE  9006
VOLUME ["/data/www/", "/var/run/"]

RUN echo '#!/bin/bash' > /init.sh && \
    echo '/usr/local/sbin/php-fpm -F' >> /init.sh && \
    chmod +x /init.sh
CMD ["/init.sh"]
