# Extra
## Exploring SNMP
You my want to test SNMP... <br>
### Own docker network
For that I fisrt create a new network. the **snmpNet**.
```
docker network create --driver bridge snmpNet
```
### SNMP simulator on Docker
I start my SNMP simulator using the image **tandrup/snmpsim**.
```
docker run -d -p 161:161/udp --network snmpNet --name snmpsimd --hostname snmpsimd tandrup/snmpsim
```
### SNMP client tools on Docker
I test the simulator using the image **elcolio/net-snmp**.
```
docker run -t --rm  --network snmpNet elcolio/net-snmp snmpwalk -v2c -c public snmpsimd:161
```
You don't need to specify the port nr. 

