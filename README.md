# osm-world-db

**Warning**: This process needs at least 1.4TB of disk space!
70GB for the osm-world pbf and at least another 400GB for the
postgres database, and additionally another
good 680GB for files that are needed to update the database (cache files).

A docker-compose setup to set up and maintain a world database.

After the initial import of the OpenStreetMap planet, this loops the update procedure indefinitely.
Thus, when one update finishes, the next update is started after a short, fixed-duration break unless the process is being terminated.

Update duration, and thus the update interval, strongly depends on the hardware used.

Per default, this world db uses the stylesheets and option defined under `styles/`
but you can customize that:

In your docker-compose file, link a volume to `/root/styles`, for example `/tmp/my_styles` and set the
environment variable `osm2pgsql_extra_args` correspondingly. 

For example: 
```
volumes:
    - /tmp/my_styles:/root/styles
environment:
    osm2pgsql_extra_args=--style /root/styles/my_style.style --tag-transform-script /root/styles/my_transform_style.lua
```

To disable custom styles altogether, just set `osm2pgsql_extra_args` to an empty string.

## Table Prefix

The table prefix has been shortened from `planet_osm` to just `osm`. If
you'd like to change that, just set an environment variable called
`table_prefix` to the prefix you want:

```
environment:
    - table_prefix=my_prefix
```

## Usage

The examples all use docker-compose for starting/stopping.

### Starting

```
docker-compose up -d
```

### Stopping

```
docker-compose down
```

### Updating

```
docker-compose down
docker-compose pull
docker-compose up -d
```

### Complete cleanup

**Warning**: this removes all the data, the entire process
will start at the beginning again.

Remove images (`--rmi`) and volumes (`-v`):

```
docker-compose down --rmi local -v
```

## Development

Make changes as usually, update inside the `Dockerfile`
the line `ENV LATEST_OSM2PGSQL_UPDATE 2016-03-23_17:40` and
add the current date, then use the `build_and_push.sh` script to
generate and upload the newest generated image to dockerhub.

### Testing

For Testing purposes, you can use Switzerland as testbed as follows
(import takes around one hour):

```
docker-compose -f docker-compose.yml -f dev.yml up
```

Or with much less runtime, use the containers directly, and you even 
can try whether the update process is working, for example with Monaco:

```
docker-compose -f docker-compose.yml -f dev.yml run --rm \
  -e osmupdate_extra_params="--base-url=download.geofabrik.de/europe/monaco-updates/" \
  -e osm_planet_mirror="http://download.geofabrik.de/" \
  -e osm_planet_path_relative_to_mirror="europe/monaco-160301.osm.pbf" \
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
