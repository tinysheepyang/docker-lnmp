FROM alpine:3.4
MAINTAINER chenshiyang <chenshiyang460@emao.com>

## Install packages
RUN apk --update add --no-cache dnsmasq && \
            rm -rf /var/cache/apk/*


## Start service
CMD ["dnsmasq", "--keep-in-foreground", "--log-facility=-"]

### allow ports
EXPOSE 53 53/udp

