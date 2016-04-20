#!/bin/bash
docker build -t geometalab/continuous-osm2pgsql:latest .
docker push geometalab/continuous-osm2pgsql:latest
docker build -f postgis.Dockerfile -t geometalab/osm_world_postgis:latest .
docker push geometalab/osm_world_postgis:latest
