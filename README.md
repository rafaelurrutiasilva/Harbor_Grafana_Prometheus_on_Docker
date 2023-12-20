# Harbor, Grafana, Prometheus on Docker
## Abstract
Utilizing a Container Host can be the easiest way to test and learn new ideas and concepts in the computer world. In this particular case, I was seeking a method to initiate testing and learning more about observability, visualization, and exploration of all metrics I could scrape.
<br>
<br>
<img width="600" alt="Overview" src="https://github.com/rafaelurrutiasilva/images/blob/main/system_overview/docker_labb01-System%20Overview.svg" align=center><br>
*Figure 01 provides an overview of the data flow for collecting metrics.*



---
## Table of Contents
1. [Introduction](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#introduction)
2. [Goals and Objectives](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#goals-and-objectives)
3. [Method](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#method)
4. [Target Audience](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#target-audience)
5. [Document Status](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#document-status)
6. [Disclaimer](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#disclaimer)
7. [Scope and Limitations](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#scope-and-limitations)
8. [Environment](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#environment)
9. [Acknowledgments](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#acknowledgments)
10. [References](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#references)
11. [Conclusion](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#conclusion)
12. [Used Ports](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#used-ports)
13. [Referenses](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#referenses)
14. [Making your Photon OS VM a Container Host](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#making-your-photon-os-vm-a-container-host)
15. [Harbor on Docker](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#harbor-on-docker)
16. [Harbor Container Network](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#harbor-container-network)
17. [Prometheus on Docker](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#prometheus-on-docker)
18. [Prometheus Node Exporter on Docker](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#prometheus-node-exporter-on-docker)
19. [Configure the Docker daemon as a Prometheus target](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#configure-the-docker-daemon-as-a-prometheus-target)
20. [Grafana on Docker](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/tree/main#grafana-on-docker)
21. [Starting or Stopping all together](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/blob/main/#starting-or-stopping-all-together)
22. [Extra](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/blob/main/#extra)

## Introduction
This repository includes instructions to guide you through the installation and execution of Harbor, Grafana, Prometheus, and Prometheus Node Exporter on a single [Photon OS](https://vmware.github.io/photon/#features) Docker Host. By following these instructions, you will gain insights into pulling and running container images on the same Container Host. Subsequently, you will be able to monitor machine and application metrics, including those of Harbor, using all the concurrently running containers.

## Goals and Objectives
Establish a baseline for a Docker Container Host based on Photon OS. Utilize the Container Host to run all applications within containers. Configure Harbor, Docker Host, and Virtual Machine to independently expose their metrics. Set up Prometheus and the Node Exporter to scrape the metrics and, finally, visualize them using Grafana with appropriate dashboards.

## Method 
I began by identifying appropriate container images for the components I intended to work with. Subsequently, I initiated the process of launching these containers. As Harbor establishes its own Docker network, my initial objective was to consolidate all components within the same network, the *harbor_harbor* network. After confirming successful container startup and the scraping of metric, I opted to establish a distinct network for Prometheus components, the *prometheus_net*. Consequently, I integrated Prometheus into both the Harbor and and its dedicated network.
<br>

<img width="600" alt="DockerNetworks" src="https://github.com/rafaelurrutiasilva/images/blob/main/system_overview/docker_labb01-Using%20Habor%20and%20Prometheus%20Docker%20Network.svg" align=center><br>
*Figure 02 provides an overview of how Docker networks are utilized.*

## Target Audience
Designed for anyone looking to navigate and gain insights into testing and learning these matters, but perhaps primarily for those, like me, who have just embarked on their journey and need a helping hand.

## Document Status
> [!NOTE]  
> My work here is not finished yet. I need, among other things, to supplement with instructions on how each component should be configured to work together as well supplement with an overview image that explains how the whole thing works.

## Disclaimer
> [!CAUTION]
> This is intended for learning, testing, and experimentation. The emphasis is not on security or creating an operational environment suitable for production.

## Scope and Limitations
A quick method to set up an environment for installing and testing Harbor, Grafana, Prometheus, and Node Exporter on a single Container Host, all with the aim of learning more about observability.<br> 
This is not intended for use as a reference for a production environment and does not focus on all the security considerations such an environment requires.

## Environment
> [!TIP]
> The following computer environment was utilized. For details regarding container image versions and other components, please refer to the respective sections in the application documentation available here.
```
Microsoft Windows 10 Enterprise, OS Version: 10.0.19045 N/A Build 19045
VMware Workstation 17 Pro, 17.5.0 build-22583795
VMware Photon OS v5.0
Docker Client Engine - Community
Version: 24.0.5, API version: 1.43, Go version: go1.20.10
Docker Server Engine - Community
Version: 24.0.5, API version: 1.43, Go version: go1.20.10
Virtual Machine
4vCPU, 8GB vRAM, 50 GB vDiskx
```

## Acknowledgments
Big thanks to all the people involved in the material I refer to in my links! I would also like to express gratitude to everyone out there, including my colleagues and friends, who are creating things that help and inspire us to continue learning and exploring this never-ending world of computer technology.

## Referenses
* [Downloading Photon OS](https://github.com/vmware/photon/wiki/Downloading-Photon-OS)
* [Prometheus Installation](https://prometheus.io/docs/prometheus/latest/installation/)
* [Prometheus Docker Compose](https://mxulises.medium.com/simple-prometheus-setup-on-docker-compose-f702d5f98579)
* [Collect Docker metrics with Prometheus](https://docs.docker.com/config/daemon/prometheus/#configure-the-daemon)
* [Node_exporter](https://github.com/prometheus/node_exporter)
* [Node exporter using Docker](https://last9.hashnode.dev/how-to-download-and-run-node-exporter-using-docker)
* [Prometheus config examples](https://grafana.com/docs/grafana-cloud/send-data/metrics/metrics-prometheus/prometheus-config-examples/docker-compose-linux)
* [Grafana on Docker](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker)
* [Harbor Configuration](https://goharbor.io/docs/2.2.0/install-config/configure-yml-file)
* [Harbor Reconfigure Manage](https://goharbor.io/docs/2.2.0/install-config/reconfigure-manage-lifecycle)
* [Harbor Scrapping Metrics](https://goharbor.io/docs/2.2.0/administration/metrics/#scrapping-metrics-with-prometheus)

## Conclusion
Creating this tutorial has provided me with valuable practical insights. The Docker Network, a complex aspect of this lab, should be set up efficiently to prioritize diving into more central topics, such as metrics and observability. I hope my guide assists you in navigating through all the steps, allowing you to concentrate on your experiments with Prometheus, metrics, and visualization using Grafana.

## Used Ports
Port | Notes
-----|------
9090 | Prometheus Server
9100 | Prometheus Node Exporter
9200 | Harbor Metrics
80   | Harbor Portal
3000 | Grafana Server 
9323 | Docker Daemon Metrics


## Making your Photon OS VM a Container Host
Photon OS provides a secure run-time environment for efficiently running containers. More information at [Frequently Asked Questions](https://github.com/vmware/photon/wiki/Frequently-Asked-Questions#photon-os-frequently-asked-questions)
```
hostnamectl hostname chost    # Setting the hostname to chost
tdnf update -y 
tdnf install tar jq docker-compose git  
systemctl start docker 
systemctl enable docker
```

## Harbor on Docker
### Get the Installer
```
curl -L https://github.com/goharbor/harbor/releases/download/v2.7.4/harbor-online-installer-v2.7.4.tgz -o harbor-online-installer-v2.7.4.tgz
tar xzvf harbor-online-installer-v2.7.4.tgz
mkdir -p /opt/harbor
```
### Configure the installer
> [!IMPORTANT]
Before you run the installer script, `install.sh`, you need to create your **harbor.yml** from the template. Will need to handle the *hostname*, *HTTS configuration*, the *Data volume*, the *skip_update* to avoid GitHub rate limiting issues as well uncomment the configuration for the *metric*. 
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
> [!IMPORTANT]
Notice how we're using the IP address of the Docker Host here.

Checking the IP number of the host.
```
hostname: "$(ip address |grep inet |grep eth0 |awk '{print$2}' |sed 's,/24,,g')"
```
### Run the installer
When `install.sh` is executed, it utilizes the values from the harbor.yml file. Should you make changes to the configuration in the *harbor.yml* file, simply run the prepare script instead of re-executing `install.sh`.
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

### Harbor Container Network
> [!important]
Docker Compose for Harbor establishes the harbor_harbor network. Start Harbor first. This network facilitates seamless communication between containers and assigns domain names, streamlining the entire setup process.
```
docker network ls
docker network inspect harbor_harbor
```
These commands can be utilized to verify the existence of the network and inspect its relationships

### Stoping the Harbor Container
```
docker-compose down
```

## Prometheus on Docker
### Basic Configuration
Create config and data directories.
```
mkdir -p /opt/prometheus/etc /opt/prometheus/data
```
Please copy the [prometheus.yml](etc/prometheus.yml) file to the /opt/prometheus/etc directory. Within the [etc](/etc) directory, you will find two files that can be utilized for different scenarios.
> [!TIP]
In my final setup, I am using the [prometheus.yml_2](etc/prometheus.yml_2) with the [prometheus_compose.yml_2](compose/prometheus_compose.yml_2)."

Continue then with the rest here.
```
chown -R nobody:nobody /opt/prometheus
chmod -R 755 /opt/prometheus
```
### Starting Prometius Container
Run the command below to create the docker network *prometheus_net* and the start the container.
```
docker network create prometheus_net
docker run -d -p 9090:9090 --name=prometheus -v /opt/prometheus/etc:/etc/prometheus -v /opt/prometheus/data:/prometheus --add-host=host.docker.external:192.168.157.131 --network prometheus_net prom/prometheus
```
> [!IMPORTANT]
Notice how we're using the IP address of the Docker Host here.

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

## Prometheus Node Exporter on Docker
### Starting Node Exporter Container
Run the command below to start the container.
```
docker run -d -p 9100:9100 --name=node_exporter  --network prometheus_net prom/node-exporter
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
## Configure the Docker daemon as a Prometheus target
To configure the Docker daemon as a Prometheus target, you need to specify the metrics-address in the *daemon.json* configuration file.
In my case I needed to create the folder `/etc/docker/` and the also the file `/etc/docker/daemon.json`.
```
{
  "experimental" : true,
  "metrics-addr" : "192.168.157.131:9323"
}
```
Restart the Docker deamon `systemctl restart docker` and test if you can see any metrics `curl 192.168.157.131:9323/metrics`.
> [!IMPORTANT]
Notice how we're using the IP address of the Docker Host here.

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
USER_GRAFANA=$(id -u grafana)":"$(id -g grafana)
docker run -d -p 3000:3000 --name=grafana --user $USER_GRAFANA -v /opt/grafana/data:/var/lib/grafana --network prometheus_net grafana/grafana-oss
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

## Starting or Stopping all together
The best approach for starting and stopping all containers is by utilizing the Docker Compose files. The Harbor installation generates one, and for the Prometheus components, you can use my [prometheus_compose.yml_2](compose/prometheus_compose.yml_2). All of these operations can be executed using:
### Starting
```
for FILE in ~/harbor/docker-compose.yml ~/prometheus/docker-compose.yml; do docker-compose -f $FILE up -d;done
```
### Stopping
```
for FILE in ~/harbor/docker-compose.yml ~/prometheus/docker-compose.yml; do docker-compose -f $FILE down;done
```
### Scripts
You can also take a look at my start and stop scripts located under my directory [script](script).

## Extra
I also attempted to address the process of scraping metrics from an SNMP environment. While I'm not certain if I will proceed with this, you can find a brief overview of how to augment this environment with an SNMP simulator and the necessary tools in my supplementary document. For more details, refer to my [Extra Document](https://github.com/rafaelurrutiasilva/Harbor_Grafana_Prometheus_on_Docker/blob/main/Extra/README.md#extra).
