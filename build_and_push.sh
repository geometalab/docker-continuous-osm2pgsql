#!/bin/bash
docker build -t geometalab/osm2pgsql:latest .
docker push geometalab/osm2pgsql:latest
