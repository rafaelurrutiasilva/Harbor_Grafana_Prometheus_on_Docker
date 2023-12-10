# Harbor Grafana Prometheus on Docker
## Introduction
This repository contains instructions to help you run Harbor, Grafana, and Prometheus and Node exporter on the same Photon OS Docker Host. <br>
VMware [Photon OS](https://vmware.github.io/photon/#features) delivers just enough of a Linux operating system to efficiently run containers.<br> 
<br>
Here, you will learn how to pull and run container images for Prometheus, Node Exporter, Grafana, and Harbor. Subsequently, you should be able to monitor machine and application metrics, including Harbor, using all the running containers.
<br>

## Environment
* OVA file from the [Downloading Photon OS](https://github.com/vmware/photon/wiki/Downloading-Photon-OS).
* VMware Photon OS v5.0
* Docker Client Engine - Community
* * Version: 24.0.5
* * API version: 1.43
* * Go version: go1.20.10

* Docker Server Engine - Community
* * Version: 24.0.5
* * API version: 1.43 (minimum version 1.12)
* * Go version: go1.20.10

## Referenses
* [Grafana on Docker](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker)
* [Prometheus Installation](https://prometheus.io/docs/prometheus/latest/installation/)
* [Node_exporter](https://github.com/prometheus/node_exporter)
* [Node exporter using Docker](https://last9.hashnode.dev/how-to-download-and-run-node-exporter-using-docker)
* [Prometheus config examples](https://grafana.com/docs/grafana-cloud/send-data/metrics/metrics-prometheus/prometheus-config-examples/docker-compose-linux)

## Installation
### Making your Photon OS VM a Container Host
```
hostnamectl hostname chost    # Setting the hostname to chost
tdnf update -y 
tdnf install tar docker-compose  
systemctl start docker 
systemctl enable docker
```

---

### Prometheus on Docker
#### Basic Configuration
Create config and data directories.
```
mkdir -p /opt/prometheus/etc /opt/prometheus/data
```
Copy now the [prometheus.yml](/etc/prometheus.yml) to `/opt/prometheus/etc`
Continue then with the rest here.
```
chown -R nobody:nobody /opt/prometheus
chmod -R 755 /opt/prometheus
```

#### Starting Prometius Container
Run the command below to start the container.
```
docker run -d -p 9090:9090 --name=prometheus  -v /opt/prometheus/etc:/etc/prometheus -v /opt/prometheus/data:/prometheus prom/prometheus
```

#### Test and surf to the address below
```
echo http://$(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,:9090,g')
```

#### Stoping Prometius Container
Run the command below to stop and remove the container.
```
docker stop prometheus; docker rm prometheus
```

---

### Grafana on Docker
#### Basic Configuration
```
groupadd grafana
useradd --no-create-home --shell /bin/false grafana
usermod -g grafana grafana
mkdir -p /opt/grafana/data
chown -R grafana:grafana  /opt/grafana
```
#### Starting Grafana Container
```
docker run -d -p 3000:3000 --name=grafana --user "$(id -u grafana)":"$(id -g grafana)" -v /opt/grafana/data:/var/lib/grafana  grafana/grafana-oss
```
#### Test and surf to the address below
Change the admin:admin passwd
```
echo http://$(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,:3000,g')
```
#### Stoping Grafana Container
```
docker stop grafana; docker rm grafana
```

---
### Harbor on Docker
#### Get the Installer
```
curl -L https://github.com/goharbor/harbor/releases/download/v2.7.4/harbor-online-installer-v2.7.4.tgz -o harbor-online-installer-v2.7.4.tgz
tar xzvf harbor-online-installer-v2.7.4.tgz
mkdir -p /opt/harbor
```

#### Configure the installer
```
cd harbor
rm ../harbor-online-installer*
mv harbor.yml.tmpl harbor.yml
```

Edit in `harbor.yml` values below and for this labb **comment out all the https configuration**.
```
data_volume: /opt/harbor
hostname: "$(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,,g')"
hostname -I
```

#### Run the installer
```
./install.sh
```

#### Starting and Test the Harbor Container
Start:
```
docker-compose up -d
```

Surf to:
```
echo "http://$(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,,g')"
```
And chage therw harbor_admin_password: Harbor12345 to VMwareVM1! for example.

#### Stoping the Harbor Container
```
docker-compose down
```
