# osm-world-db

*Warning*: This process needs at least 400GB of disk space!
70GB for the osm-world pbf and at least another 200GB for the
postgres database, and additionally another
good 20GB for files that are needed to update the database.

A collection to setup and maintain a world database.

Currently, update speed depends solely on the hardware used.
They are being run as soon as that the run before has finished.

## Usage

Using docker-compose:
```
docker-compose pull
docker-compose run osm_importer
```

## Development

Make changes as usually, then use the `build_and_push.sh` script to
generate and upload the newest generated image to dockerhub.
