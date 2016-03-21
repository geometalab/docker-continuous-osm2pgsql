#!/bin/bash
# WORKDIR_OSM=/var/data/osm-planet/update
# mkdir -p ${WORKDIR_OSM}
# osmosis/bin/osmosis --read-replication-interval-init workingDirectory=${WORKDIR_OSM}
# osmosis/bin/osmosis --read-replication-interval workingDirectory=${WORKDIR_OSM} --simplify-change \
#  --write-xml-change - | osm2pgsql --append --keep-coastlines \
#    -H database -U gis -d gis --slim -C 30000 \
#    --flat-nodes /var/cache/osm-cache -

osmupdate -v /var/data/osm-planet/pbf/planet-latest.osm.pbf /var/data/osm-planet/pbf/planet-latest.osc.gz && \
# osm2pgsql --append -keep-coastlines \
#   -H database -U gis -d gis --slim -C 30000 \
#   --flat-nodes /var/cache/osm-cache /var/data/osm-planet/pbf/planet-latest.osc.gz && \
osmconvert -v /var/data/osm-planet/pbf/planet-latest.osm.pbf /var/data/osm-planet/pbf/planet-latest.osc.gz -o=/var/data/osm-planet/pbf/planet-latest.osm.pbf &&
rm -f /var/data/osm-planet/pbf/planet-latest.osc.gz
