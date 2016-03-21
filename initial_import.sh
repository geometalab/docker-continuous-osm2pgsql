#!/bin/bash
osm2pgsql -c --number-processes 8 --keep-coastlines \
  -H database -U gis -d gis --slim -C 30000 \
  --flat-nodes /var/cache/osm-cache \
  /var/data/osm-planet/pbf/planet-latest.osm.pbf
