FROM postgres:9.5

MAINTAINER njordan@hsr.ch

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ENV POSTGIS_MAJOR 2.1

RUN ["echo", "deb http://http.debian.net/debian jessie-backports main", ">>", "/etc/apt/sources.list"]
RUN DEBIAN_FRONTEND=noninteractive apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get -y install\
    postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}\
    postgresql-${PG_MAJOR}-postgis-scripts

COPY ./docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
