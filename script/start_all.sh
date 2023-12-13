#!/bin/bash
HARBOR_COMPOSE_FILE=~/harbor/docker-compose.yml
CONTAINERS="prometheus node-exporter grafana"


echo "Starting Harbor... this create a harbor_harbor bridge network as well!"
docker-compose -f $HARBOR_COMPOSE_FILE up -d

if [[ ! $(docker network ls -f name=harbor_harbor -q ) ]];then
                echo "ERROR - The harbor_harbor docker network is missing!"
                exit
else
        NETWORK="--network harbor_harbor"
fi

echo "Starting Prometheus"
docker run -d -p 9090:9090 --name=prometheus  -v /opt/prometheus/etc:/etc/prometheus -v /opt/prometheus/data:/prometheus $NETWORK prom/prometheus

echo "Starting Node Exporter"
docker run -d -p 9100:9100 --name=node-exporter $NETWORK prom/node-exporter

echo "Starting Grafana"
docker run -d -p 3000:3000 --name=grafana --user "$(id -u grafana)":"$(id -g grafana)" -v /opt/grafana/data:/var/lib/grafana  $NETWORK grafana/grafana-oss
