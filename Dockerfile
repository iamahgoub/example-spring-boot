FROM ubuntu:20.04

ENV JAVA_HOME /opt/jdk
ENV PATH $JAVA_HOME/bin:$PATH

ADD "https://github.com/CRaC/openjdk-builds/releases/download/17-crac%2B3/openjdk-17-crac+3_linux-x64.tar.gz" $JAVA_HOME/openjdk.tar.gz

RUN apt-get update -y \
    && tar --extract --file $JAVA_HOME/openjdk.tar.gz --directory "$JAVA_HOME" --strip-components 1  \
    && rm $JAVA_HOME/openjdk.tar.gz  \
    && mkdir -p /opt/crac-files
COPY target/spring-boot-initial-0.0.1-SNAPSHOT.jar /opt/app/spring-boot-initial-0.0.1-SNAPSHOT.jar
COPY --chmod=500 scripts/* /opt/scripts/