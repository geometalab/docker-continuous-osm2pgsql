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
  python

WORKDIR /root/osm2pgsql
RUN git clone git://github.com/openstreetmap/osm2pgsql.git /root/osm2pgsql
RUN mkdir build
WORKDIR /root/osm2pgsql/build
RUN cmake ..
RUN make && make install

RUN echo 'database:5432:gis:gis:gis' > /root/.pgpass
RUN chmod 0600 /root/.pgpass

WORKDIR /root
