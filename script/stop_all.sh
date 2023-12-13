#!/bin/bash
HARBOR_COMPOSE_FILE=~/harbor/docker-compose.yml
CONTAINERS="prometheus node-exporter grafana"

echo "Stopping all Containers"
docker-compose -f $HARBOR_COMPOSE_FILE down
docker stop $CONTAINERS
docker rm $CONTAINERS
