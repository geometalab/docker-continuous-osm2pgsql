FROM debian:jessie

RUN apt-get update && apt-get install -y \
  make \
  cmake \
  g++ \
  libboost-dev \
  libboost-system-dev \
  libboost-filesystem-dev \
  libexpat1-dev \
  zlib1g-dev \
  libbz2-dev \
  libpq-dev \
  libgeos-dev \
  libgeos++-dev \
  libproj-dev lua5.2 \
  liblua5.2-dev \
  git \
  python-dev \
  python \
  osmctools \
  wget \
  gzip \
  tar

WORKDIR /root/osmupdate

RUN wget -O - http://m.m.i24.cc/osmupdate.c | cc -x c - -o osmupdate

WORKDIR /root/osm2pgsql
ENV LATEST_OSM2PGSQL_UPDATE 2016-04-11_16:09
RUN wget -O osm2pgsql.tar.gz https://github.com/openstreetmap/osm2pgsql/archive/0.90.0.tar.gz
RUN tar -xf /root/osm2pgsql/osm2pgsql.tar.gz
WORKDIR /root/osm2pgsql/osm2pgsql-0.90.0
RUN mkdir build
WORKDIR /root/osm2pgsql/osm2pgsql-0.90.0/build
RUN cmake ..
RUN make && make install

ENV POSTGRES_PORT 5432
ENV POSTGRES_HOST database
RUN echo 'database:5432:gis:gis:gis' > /root/.pgpass
RUN chmod 0600 /root/.pgpass

COPY ./styles /root/styles

WORKDIR /root

COPY ./wait-for-it/wait-for-it.sh /root/wait-for-it.sh
COPY ./run.sh /root/run.sh
