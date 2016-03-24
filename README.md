# osm-world-db

**Warning**: This process needs at least 600GB of disk space!
70GB for the osm-world pbf and at least another 200GB for the
postgres database, and additionally another
good 20GB for files that are needed to update the database.

A docker-compose setup to set up and maintain a world database.

After the initial import of the OpenStreetMap planet, this loops the update procedure indefinitely.
Thus, when one update finishes, the next update is started after a short, fixed-duration break unless the process is being terminated.

Update duration, and thus the update interval, strongly depends on the hardware used.

## Usage

The examples all use docker-compose for starting/stopping.

### Starting

```
docker-compose pull
docker-compose up -d osm_importer
```

### Stopping

```
docker-compose kill osm_importer
```

### Updating

```
docker-compose kill osm_importer
docker-compose rm osm_importer
docker-compose pull
docker-compose up -d osm_importer
```

## Development

Make changes as usually, update inside the `Dockerfile`
the line `ENV LATEST_OSM2PGSQL_UPDATE 2016-03-23_17:40` and
add the current date, then use the `build_and_push.sh` script to
generate and upload the newest generated image to dockerhub.

### Testing

For Testing purposes, you can use Switzerland as testdata as follows:

Maybe replace europe/switzerland-160321.osm.pbf with a less out of date
file, so the update process doesn't take so long.

```
docker-compose up -d postgis
# wait 10 seconds
docker-compose run --rm \
  -e osmupdate_extra_params="--base-url=download.geofabrik.de/europe/switzerland-updates/" \
  -e osm_planet_mirror="http://download.geofabrik.de/" \
  -e osm_planet_path_relative_to_mirror="europe/switzerland-160321.osm.pbf" \
  osm_importer
```

or with much less runtime, use Andorra:

```
docker-compose up -d postgis
# wait 10 seconds
docker-compose run --rm \
  -e osmupdate_extra_params="--base-url=download.geofabrik.de/europe/andorra-updates/" \
  -e osm_planet_mirror="http://download.geofabrik.de/" \
  -e osm_planet_path_relative_to_mirror="europe/andorra-160320.osm.pbf" \
  osm_importer
```
