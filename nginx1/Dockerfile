FROM centos:centos6

COPY nginx.repo /etc/yum.repos.d
RUN yum -y update && yum install wget nginx gcc vim -y && yum clean all

ADD config/* /etc/nginx/

# Attach volumes.
VOLUME ["/data/www"]

# SET WORKING DIRECTORY.
WORKDIR /etc/nginx

# EXPOSE PORTS.
EXPOSE 80
EXPOSE 443

# DEFINE DEFAULT COMMAND.
ENTRYPOINT ["nginx"]

