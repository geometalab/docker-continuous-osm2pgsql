FROM debian:jessie

# osm2pgsql dependencies
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

# osmosis dependencies
RUN apt-get update && apt-get install -y \
  default-jre \
  wget \
  gzip \
  tar


# osmosis dependencies
RUN apt-get update && apt-get install -y \
  osmctools

WORKDIR /root/osmupdate

RUN wget -O - http://m.m.i24.cc/osmupdate.c | cc -x c - -o osmupdate

WORKDIR /root/osmosis

RUN echo 'JAVACMD_OPTIONS=-server' > /root/.osmosis
RUN echo 'JAVACMD_OPTIONS=-Xmx20G' >> /root/.osmosis

RUN wget http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-latest.tgz
RUN tar -xf osmosis-latest.tgz

WORKDIR /root/osm2pgsql
RUN git clone git://github.com/openstreetmap/osm2pgsql.git /root/osm2pgsql
RUN mkdir build
WORKDIR /root/osm2pgsql/build
RUN cmake ..
RUN make && make install

RUN echo 'database:5432:gis:gis:gis' > /root/.pgpass
RUN chmod 0600 /root/.pgpass

WORKDIR /root

COPY ./initial_import.sh /root/initial_import.sh
COPY ./update_db.sh /root/update_db.sh
