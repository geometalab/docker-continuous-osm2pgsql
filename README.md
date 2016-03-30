# osm-world-db

**Warning**: This process needs at least 1.4TB of disk space!
70GB for the osm-world pbf and at least another 400GB for the
postgres database, and additionally another
good 680GB for files that are needed to update the database (cache files).

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
  -e osm_planet_path_relative_to_mirror="europe/switzerland-160301.osm.pbf" \
  osm_importer
```

or with much less runtime, use Andorra:

```
docker-compose up -d postgis
# wait 10 seconds
docker-compose run --rm \
  -e osmupdate_extra_params="--base-url=download.geofabrik.de/europe/andorra-updates/" \
  -e osm_planet_mirror="http://download.geofabrik.de/" \
  -e osm_planet_path_relative_to_mirror="europe/andorra-160301.osm.pbf" \
  osm_importer
```

### Postgres run options

Most options can be provided through the command line, for complete list
you can run `docker run --rm geometalab/postgis:9.5 postgres --help`.

The ones we are using are:

```
  -B NBUFFERS        number of shared buffers
  -F                 turn fsync off
  -N MAX-CONNECT     maximum number of allowed connections
  -S WORK-MEM        set amount of memory for sorts (in kB)
  --max_wal_size=5GB set max_wal_size to 5GB
```
