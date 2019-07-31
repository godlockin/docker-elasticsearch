# Pull base image.
FROM lockinwu/centos7-openjdk11

MAINTAINER godlockin <stevenchenworking@gmail.com>

USER elasticsearch

ENV ES_VERSION 7.2.0
ENV ES_PKG_NAME elasticsearch-$ES_VERSION
ENV ES_PKG_FILE_NAME $ES_PKG_NAME-linux-x86_64

ENV JAVA_HOME=/usr/lib/jvm/java-openjdk
ENV PATH=$PATH:$JAVA_HOME/bin:.

# Install Elasticsearch.
RUN yum update -y
RUN yum install -y wget
RUN wget -c https://artifacts.elastic.co/downloads/elasticsearch/$ES_PKG_FILE_NAME.tar.gz /
RUN cd /
RUN sudo tar vxf $ES_PKG_FILE_NAME.tar.gz
RUN mv /$ES_PKG_NAME /elasticsearch
RUN groupadd -g 1000 elasticsearch 
RUN adduser -g 1000 -u 1000 elasticsearch 
RUN chown -R elasticsearch:elasticsearch /elasticsearch

# Define mountable directories.
VOLUME ["/data"]

# Mount elasticsearch.yml config
ADD config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Define working directory.
WORKDIR /data

USER elasticsearch:elasticsearch

# Define default command.
CMD ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300
