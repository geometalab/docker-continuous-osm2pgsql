# osm-world-db

**Warning**: This process needs at least 400GB of disk space!
70GB for the osm-world pbf and at least another 200GB for the
postgres database, and additionally another
good 20GB for files that are needed to update the database.

A docker-compose setup to set up and maintain a world database.

After the initial import of the OpenStreetMap planet, this loops the update procedure indefinitely.
Thus, when one update finishes, the next update is started after a short, fixed-duration break unless the process is being terminated.

Update duration, and thus the update interval, strongly depends on the hardware used.

## Usage

Using docker-compose:
```
docker-compose pull
docker-compose run osm_importer
```

## Development

Make changes as usually, then use the `build_and_push.sh` script to
generate and upload the newest generated image to dockerhub.
