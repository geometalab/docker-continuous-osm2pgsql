#!/bin/bash
set -e
nice="nice -n 19"
num_processes=${num_processes:-8}
osm_cache=/var/cache/osm-cache
osm2pgsql_base_args="--number-processes ${num_processes} --keep-coastlines -H database -U gis -d gis --slim -C 30000 --flat-nodes ${osm_cache}"
osm_planet_base_dir="/var/data/osm-planet"
pbf_dir="${osm_planet_base_dir}/pbf"
osm_planet_mirror="${osm_planet_mirror:-http://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org}"
osm_planet_path_relative_to_mirror="${osm_planet_path_relative_to_mirror:-/pbf/planet-latest.osm.pbf}"
complete_planet_mirror_url="${osm_planet_mirror}${osm_planet_path_relative_to_mirror}"
planet_latest="${pbf_dir}/planet-latest.osm.pbf"
planet_diff="${pbf_dir}/planet-latest.osc.gz"

initial_import() {
  mkdir -p ${pbf_dir}
  ${nice} wget -O ${planet_latest}_tmp ${complete_planet_mirror_url}
  ${nice} mv ${planet_latest}_tmp ${planet_latest}
  ${nice} osm2pgsql -c ${osm2pgsql_base_args} ${planet_latest}
  touch ${osm_planet_base_dir}/db_initial_import_completed
}

update() {
  # all steps are idempotent, they can be repeated without information loss/duplication
  ${nice} osmupdate -v ${osmupdate_extra_params} ${planet_latest} ${planet_diff}_tmp || true
  if [ -f "${planet_diff}_tmp" ]; then
    ${nice} mv ${planet_diff}_tmp ${planet_diff}
    ${nice} osm2pgsql --append ${osm2pgsql_base_args} ${planet_diff}
    ${nice} osmconvert -v ${planet_latest} ${planet_diff} -o=${pbf_dir}/planet-latest-new.osm.pbf
    ${nice} mv ${pbf_dir}/planet-latest-new.osm.pbf ${planet_latest}
    ${nice} rm ${planet_diff}
  fi
}

if [ ! -f "${osm_planet_base_dir}/db_initial_import_completed" ]; then
  initial_import
fi

while [ 1 ]
do
  update
  sleep 10
done
