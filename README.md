# Harbor, Grafana, Prometheus on Docker
## Introduction
This repository contains instructions to help you run Harbor, Grafana, and Prometheus and Node exporter on the same Photon OS Docker Host.
VMware [Photon OS](https://vmware.github.io/photon/#features) delivers just enough of a Linux operating system to efficiently run containers.<br> 
<br>
Here, you will learn how to pull and run container images for Prometheus, Node Exporter, Grafana, and Harbor. Subsequently, you should be able to monitor machine and application metrics, including Harbor, using all the running containers.
<br>

---
## STATUS
> [!warning]
> My work here is not finished yet. I need, among other things, to supplement with instructions on how each component should be configured to work together as well supplement with an overview image that explains how the whole thing works.
 
---
## TABLE OF CONTENTS
1. [Used Environment](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#environment)
2. [Used Ports](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#used-ports)
3. [Referenses](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#referenses)
4. [Making your Photon OS VM a Container Host](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#making-your-photon-os-vm-a-container-host)
5. [Prometheus on Docker](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#prometheus-on-docker)
6. [Prometheus Node Exporter on Docker](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#prometheus-node-exporter-on-docker)
7. [Grafana on Docker](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#grafana-on-docker)
8. [Harbor on Docker](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#harbor-on-docker)
9. [Starting or Stopping all together](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/blob/main/README.md#starting-or-stopping-all-together)
10.[Exploring SNMP](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/blob/main/README.md#exploring-snmp)


---
## Used Environment
> [!important]
> The following basic environment was used for all containers component see information from respectively application.
* Microsoft Windows 10 Enterprise, OS Version: 10.0.19045 N/A Build 19045
 * VMware Workstation 17 Pro, 17.5.0 build-22583795
 * OVA file from the [Downloading Photon OS](https://github.com/vmware/photon/wiki/Downloading-Photon-OS).
 * VMware Photon OS v5.0
 * Docker Client Engine - Community
 * * Version: 24.0.5, API version: 1.43, Go version: go1.20.10
 * Docker Server Engine - Community
 * * Version: 24.0.5, API version: 1.43, Go version: go1.20.10
 * Virtual Machine
 * * 4vCPU, 8GB vRAM, 50 GB vDiskx
 

## Referenses
* [Grafana on Docker](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker)
* [Prometheus Installation](https://prometheus.io/docs/prometheus/latest/installation/)
* [Prometheus Docker Compose](https://mxulises.medium.com/simple-prometheus-setup-on-docker-compose-f702d5f98579)
* [Node_exporter](https://github.com/prometheus/node_exporter)
* [Node exporter using Docker](https://last9.hashnode.dev/how-to-download-and-run-node-exporter-using-docker)
* [Prometheus config examples](https://grafana.com/docs/grafana-cloud/send-data/metrics/metrics-prometheus/prometheus-config-examples/docker-compose-linux)
* [Harbor Configuration](https://goharbor.io/docs/2.2.0/install-config/configure-yml-file)
* [Harbor Reconfigure Manage](https://goharbor.io/docs/2.2.0/install-config/reconfigure-manage-lifecycle)
* [Harbor Scrapping Metrics](https://goharbor.io/docs/2.2.0/administration/metrics/#scrapping-metrics-with-prometheus)
* [SNMP Simulator](https://github.com/tandrup/docker-snmpsim)
* [Image with Net-SNMP binaries](https://hub.docker.com/r/elcolio/net-snmp)

## Used Ports
Port | Notes
-----|------
9090 | Prometheus Server
9100 | Prometheus Node Exporter
9200 | Harbor metrics
3000 | Grafana Server 

## Making your Photon OS VM a Container Host
Photon OS provides a secure run-time environment for efficiently running containers. More information at [Frequently Asked Questions](https://github.com/vmware/photon/wiki/Frequently-Asked-Questions#photon-os-frequently-asked-questions)
```
hostnamectl hostname chost    # Setting the hostname to chost
tdnf update -y 
tdnf install tar jq docker-compose  
systemctl start docker 
systemctl enable docker
```

---

## Container Host Network
> [!important]
The docker-compose for Habor create the **harbor_harbor** docker network. Is import that Harbor starts first and all the rest of the containers are also started in the samme network. This network facilitates seamless communication between containers and assigns domain names, streamlining the entire setup process.
```
docker network ls
docker network inspect harbor_harbor
```

---
## Harbor on Docker
### Get the Installer
```
curl -L https://github.com/goharbor/harbor/releases/download/v2.7.4/harbor-online-installer-v2.7.4.tgz -o harbor-online-installer-v2.7.4.tgz
tar xzvf harbor-online-installer-v2.7.4.tgz
mkdir -p /opt/harbor
```
### Configure the installer
> [!important]
Before you run the installer script, `install.sh`, you need to create your **harbor.yml** from the template. Will need to handle the **hostname**, **HTTS configuration**, the **Data volume**, the **skip_update** to avoid GitHub rate limiting issues as well uncomment the configuration for the **metric**. 
```
cd harbor
rm ../harbor-online-installer*
mv harbor.yml.tmpl harbor.yml
```
I my ** harbor.yml** I'm using `data_volume: /opt/harbor`, my IP nr as hostname, no SSL (HTTPS part is commented out) and metric configuration as below.
```
hostname: 192.168.157.131
.
.
.
metric:
   enabled: true
   port: 9200
   path: /metrics
.
.
.
data_volume: /opt/harbor
.
.
.
trivy:
  skip_update: true
.
.
. 
```

```
hostname: "$(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,,g')"
```
### Run the installer
Everytime the `install.sh` is run, all the values in the file **harbor.yml** will be used!
```
./install.sh
```

### Starting and Test the Harbor Container
Start:
```
docker-compose up -d
```
Surf to:
```
echo "The Node IP address is $(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,,g')"
echo  http://$(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,,g')
```
And chage therw harbor_admin_password: Harbor12345 to VMwareVM1! for example.

### Stoping the Harbor Container
```
docker-compose down
```
---
## Prometheus on Docker
### Basic Configuration
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
### Starting Prometius Container
Run the command below to start the container.
```
docker run -d -p 9090:9090 --name=prometheus  -v /opt/prometheus/etc:/etc/prometheus -v /opt/prometheus/data:/prometheus  --network harbor_harbor prom/prometheus
```
### Test and surf to the address below
```
echo "The Node IP address is $(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,,g')"
curl -L  http://$(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,:9090,g')
```
### Stoping Prometius Container
Run the command below to stop and remove the container.
```
docker stop prometheus; docker rm prometheus
```

---
## Prometheus Node Exporter on Docker
### Starting Node Exporter Container
Run the command below to start the container.
```
docker run -d -p 9100:9100 --name=node_exporter  --network harbor_harbor prom/node-exporter
```
### Testing the metrics are exported
```
echo "The Node IP address is $(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,,g')"
curl -L "http://$(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,:9100,g')/metrics"
```
### Stoping Node Exporter Container
Run the command below to stop and remove the container.
```
docker stop node_exporter; docker rm node_exporter
```

---
## Grafana on Docker
### Basic Configuration
```
groupadd grafana
useradd --no-create-home --shell /bin/false grafana
usermod -g grafana grafana
mkdir -p /opt/grafana/data
chown -R grafana:grafana  /opt/grafana
```
### Starting Grafana Container
```
docker run -d -p 3000:3000 --name=grafana --user "$(id -u grafana)":"$(id -g grafana)" -v /opt/grafana/data:/var/lib/grafana   --network harbor_harbor grafana/grafana-oss
```
### Test and surf to the address below
Change the admin:admin passwd
```
echo "The Node IP address is $(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,,g')"
curl -L  http://$(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,:3000,g')
```
### Stoping Grafana Container
```
docker stop grafana; docker rm grafana
```

---
## Starting or Stopping all together
### Starting all
```
if [[ ! $(docker network ls -f name=LocalLab -q ) ]];then
        echo "Creatig a 'docker network' of type 'bridge' named 'LocalLab'"
        docker network create --driver bridge LocalLab
fi
echo "Starting Prometheus"
docker run -d -p 9090:9090 --name=prometheus  -v /opt/prometheus/etc:/etc/prometheus -v /opt/prometheus/data:/prometheus --network=LocalLab prom/prometheus
echo "Starting Node Exporter"
docker run -d -p 9100:9100 --name=node_exporter --network=LocalLab prom/node-exporter
echo "Starting Grafana"
docker run -d -p 3000:3000 --name=grafana --user "$(id -u grafana)":"$(id -g grafana)" -v /opt/grafana/data:/var/lib/grafana  --network=LocalLab grafana/grafana-oss
echo "Starting Harbor"
docker-compose -f harbor/docker-compose.yml up -d
```
### Stopping all
```
echo "Stopping all Containers"
docker stop prometheus node_exporter grafana
docker rm prometheus node_exporter grafana
docker-compose -f harbor/docker-compose.yml down
if [[ $(docker network ls -f name=LocalLab -q ) ]];then
        echo "Removing the 'docker network' LocalLab "
        docker network rm LocalLab
fi
```

---
## Exploring SNMP
You my want to test SNMP... <br>
1. For that I fisrt create a new network. the **snmpNet**.
2. I start my SNMP simulator using the image **tandrup/snmpsim**.
3. I test the simulator using the image **elcolio/net-snmp**.
```
docker network create --driver bridge snmpNet
docker run -d -p 161:161/udp --network snmpNet --name snmpsimd --hostname snmpsimd tandrup/snmpsim
docker run -t --rm  --network snmpNet elcolio/net-snmp snmpwalk -v2c -c public snmpNet.snmpd:161
```
