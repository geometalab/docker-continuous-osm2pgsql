#!/bin/bash
osmupdate -v /var/data/osm-planet/pbf/planet-latest.osm.pbf /var/data/osm-planet/pbf/planet-latest.osc.gz && \
# osm2pgsql --append -keep-coastlines \
#   -H database -U gis -d gis --slim -C 30000 \
#   --flat-nodes /var/cache/osm-cache /var/data/osm-planet/pbf/planet-latest.osc.gz && \
mv /var/data/osm-planet/pbf/planet-latest.osm.pbf /var/data/osm-planet/pbf/planet-old.osm.pbf &&
osmconvert -v /var/data/osm-planet/pbf/planet-old.osm.pbf /var/data/osm-planet/pbf/planet-latest.osc.gz -o=/var/data/osm-planet/pbf/planet-latest.osm.pbf &&
rm -f /var/data/osm-planet/pbf/planet-old.osm.pbf /var/data/osm-planet/pbf/planet-latest.osc.gz
