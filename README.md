# Harbor Grafana Prometheus on Docker
## Introduction
This repository contains instructions to help you run Harbor, Grafana, and Prometheus on the same Docker host. <br>

## Environment
* VMware Photon OS v5.0
* Docker Client Engine - Community
* * Version: 24.0.5
* * API version: 1.43
* * Go version: go1.20.10

* Docker Server Engine - Community
* * Version: 24.0.5
* * API version: 1.43 (minimum version 1.12)
* * Go version: go1.20.10

## Installation
### Photon OS Configuration
```
hostnamectl hostname chost    # Setting the hostname to chost
tdnf update -y 
tdnf install tar -y 
tdnf install docker-compose –y 
systemctl start docker 
systemctl enable docker
```

### Prometheus on Docker
Installation guide from [prometheus.io](https://prometheus.io/docs/prometheus/latest/installation/)
#### Basic Configuration
```
groupadd prometheus
useradd --no-create-home --shell /bin/false prometheus
mkdir -p /opt/prometheus/etc /opt/prometheus/data
chown -R prometheus:prometheus  /opt/prometheus
```
#### Starting Prometius Container
```
docker run -d -p 9090:9090 --name=prometheus --user "$(id -u prometheus)":"$(id -g prometheus)" -v /opt/prometheus/etc/prometheus.yml:/etc/prometheus/prometheus.yml -v /opt/prometheus/data:/prometheus prom/prometheus
```
#### Stoping Prometius Container
```
docker stop prometheus; docker rm prometheus
```

### Grafana on Docker
Installation guide from [grafana.com](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker)
#### Basic Configuration
```
groupadd grafana
useradd --no-create-home --shell /bin/false grafana
mkdir -p /opt/grafana/data
chown -R grafana:grafana  /opt/grafana
```
#### Startin Grafana Container
```
docker run -d -p 3000:3000 --name=grafana --user "$(id -u grafana)":"$(id -g grafana)" -v /opt/grafana/data:/var/lib/grafana  grafana/grafana-oss
```
#### Stoping Grafana Container
```
docker stop grafana; docker rm grafana
```
