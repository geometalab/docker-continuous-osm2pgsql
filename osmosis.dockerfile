FROM debian:jessie

RUN apt-get update && apt-get install -y \
  default-jre \
  wget \
  gunzip \
  tar

WORKDIR /root/osmosis

RUN wget http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-latest.tgz
