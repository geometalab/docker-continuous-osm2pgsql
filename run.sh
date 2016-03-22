#!/bin/bash
set -e
nice="nice -n 19"
osm2pgsql_base_args="--number-processes 8 --keep-coastlines -H database -U gis -d gis --slim -C 30000 --flat-nodes /var/data/osm-cache"
osm_planet_base_path="/var/data/osm-planet/"
planet_latest="${osm_planet_base_path}pbf/planet-latest.osm.pbf"
planet_diff="${osm_planet_base_path}pbf/planet-latest.osc.gz"

initial_import() {
  mkdir -p ${osm_planet_base_path}pbf
  ${nice} wget -O ${planet_latest} http://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/pbf/planet-latest.osm.pbf
  ${nice} osm2pgsql -c "${osm2pgsql_base_args}" ${planet_latest}
}

update() {
  ${nice} osmupdate -v ${planet_latest} ${planet_diff}
  ${nice} osm2pgsql --append "${osm2pgsql_base_args}" ${planet_diff}
  ${nice} osmconvert -v ${planet_latest} ${planet_diff} -o=${osm_planet_base_path}pbf/planet-latest-new.osm.pbf
  # TODO: maybe shutdown workers
  ${nice} mv ${osm_planet_base_path}pbf/planet-latest-new.osm.pbf ${planet_latest}
  # TODO: maybe startup workers
  ${nice} rm -f ${planet_diff}
}

# only download and import if planet doesn't exist yet
if [ ! -f "${planet_latest}" ]; then
  initial_import
fi

while [ 1 ]
do
  update
  sleep 10
done