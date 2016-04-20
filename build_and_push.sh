#!/bin/bash
docker build -t geometalab/continuous-osm2pgsql:latest .
docker push geometalab/continuous-osm2pgsql:latest
