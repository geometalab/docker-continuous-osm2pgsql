#!/bin/bash
docker build -f osm2pqsgl.dockerfile -t geometalab/osm2pgsql:latest .
docker push geometalab/osm2pgsql:latest
