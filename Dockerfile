# Extend from Alpine open-jdk
FROM openjdk:8-jre-alpine3.7

# Set Maintainer
LABEL authors="Vernon Chapman <g8tor692@gmail.com>"

# Set to latest version on https://jena.apache.org/download/
ENV VERSION 3.6.0

# Set Jena Library vars
ENV JENA_HOME /opt/jena
ENV JENA_FILE apache-jena-$VERSION.tar.gz

# Change based on MD5 on https://jena.apache.org/download/
ENV JENA_MD5 bc1f8294d647cabeb37bdc6928470c03 

# Add Jena Bn to $PATH
ENV PATH $PATH:$JENA_HOME/bin

# Set Fuseki Server vars
ENV FUSEKI_HOME /opt/fuseki
ENV FUSEKI_BASE: $FUSEKI_HOME/run
ENV FUSEK_FILE apache-jena-fuseki-$VERSION.tar.gz

# Change based on MD5 on https://jena.apache.org/download/
ENV FUSEKI_MD5 37fa6d99c2d0b6546d708213b39bc540

# Set vars for URLs for 
ENV MIRROR_SITE http://www.us.apache.org/dist/jena/binaries
ENV ARCHIVE_SITE http://archive.apache.org/dist/jena/binaries

# Change Working Directory
WORKDIR /tmp

RUN echo "$FUSEKI_MD5  fuseki-$VERSION.tar.gz" > fuseki-$VERSION.tar.gz.md5 && \
    echo "$JENA_MD5  jena-$VERSION.tar.gz" > jena-$VERSION.tar.gz.md5 && \
    mkdir -p /opt/rdf

# Download, check, unpack and move JENA & FUSEKI packages
RUN wget -O fuseki-$VERSION.tar.gz $ARCHIVE_SITE/$FUSEK_FILE || \
    wget -O fuseki-$VERSION.tar.gz $MIRROR_SITE/$FUSEK_FILE && \
    md5sum -c fuseki-$VERSION.tar.gz.md5 && \
    wget -O jena-$VERSION.tar.gz $ARCHIVE_SITE/$JENA_FILE || \
    wget -O jena-$VERSION.tar.gz $MIRROR_SITE/$JENA_FILE && \
    md5sum -c jena-$VERSION.tar.gz.md5 && \
    tar -zxf fuseki-$VERSION.tar.gz && \
    mv apache-jena-fuseki-$VERSION $FUSEKI_HOME && \
    rm fuseki-$VERSION.tar.gz* && \
    tar -zxf jena-$VERSION.tar.gz && \
    mv apache-jena-$VERSION $JENA_HOME && \
    rm jena-$VERSION.tar.gz* && \
    cd $FUSEKI_HOME && rm -rf *.war *.bat && \
    cd $JENA_HOME && rm -rf *javadoc* *src* bat

WORKDIR $FUSEKI_HOME



