# gobgp_inet_container

This is a container that packages [GoBGP](https://github.com/osrg/gobgp/tree/master) together with [pfx_parser](https://github.com/mmareimorsy/pfx_parser) & [gobgp_inet_updater](https://github.com/mmareimorsy/gobgp_inet_updater), combined together this works as a way to have a BGP client with an internet routing table RIB for IPv4 & IPv6 that can be sent to networking devices under test.

The image can be used through [docker hub](https://hub.docker.com/r/mmareimorsy85/gobgp_inet_container)

## Example

A quick way to try this is to use the container in [container lab](https://containerlab.dev/), this repo contains a setup made of a gobgp_inet_container together with an Arista cEOS & Nokia SRL containers

```
cd gobgp_clab_setup
sudo containerlab deploy -t setup.yml
```

The above assumes you have download access for the images (Arista's cEOS image specifically will have to be downloaded & loaded to local docker)

Once topology is built

Setup GoBGP with the baked in config, or edit it as needed
```
docker exec -it clab-gobgp-container-gobgp /bin/bash

root@gobgp:~/gobgp# ./iplinks.sh

root@gobgp:~/gobgp# gobgpd -f gobgp_config.toml &

root@gobgp:~/gobgp# gobgp neighbor
Peer            AS  Up/Down State       |#Received  Accepted
192.168.1.1  65100 00:00:01 Establ      |        0         0
192.168.2.1  65100 00:00:06 Establ      |        0         0
192:168:1::1 65100 00:00:02 Establ      |        0         0
192:168:2::1 65100 00:00:06 Establ      |        0         0
```

Then you can use gobgp_client.py to send prefixes

```
root@gobgp:~/gobgp# gobgp_client.py --json_rib ipv4_rib.json --num_prefixes 100
INFO :: 05/26/2023 06:43:10 AM :: Processing rib file ipv4_rib.json
INFO :: 05/26/2023 06:43:10 AM :: Sent 100 prefixes out of a total of 100 expected prefixes

root@gobgp:~/gobgp# gobgp_client.py --json_rib ipv6_rib.json --num_prefixes 100
INFO :: 05/29/2023 09:13:12 PM :: Processing rib file ipv6_rib.json
INFO :: 05/29/2023 09:13:12 PM :: Sent 100 prefixes out of a total of 100 expected prefixes
```

From the devices connected in the topology you can see the RIB getting updated as prefixes get sent from GoBGP client 

```
ceos1#show bgp summary
BGP summary information for VRF default
Router identifier 192.168.2.1, local AS number 65100
Neighbor              AS Session State AFI/SAFI                AFI/SAFI State   NLRI Rcd   NLRI Acc  
------------ ----------- ------------- ----------------------- -------------- ---------- ----------  
192.168.2.2        65101 Established   IPv4 Unicast            Negotiated            100        100  
192:168:2::2       65101 Established   IPv6 Unicast            Negotiated            100        100
```

```
A:srl1# show network-instance default protocols bgp neighbor
-----------------------------------------------------------------------------------------------------BGP neighbor summary for network-instance "default"
Flags: S static, D dynamic, L discovered by LLDP, B BFD enabled, - disabled, * slow
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+----------+----------+----------+----------+----------+----------+----------+----------+ 
| Net-Inst |   Peer   |  Group   |  Flags   | Peer-AS  |  State   |  Uptime  | AFI/SAFI | [Rx/Acti | 
|          |          |          |          |          |          |          |          |  ve/Tx]  | 
+==========+==========+==========+==========+==========+==========+==========+==========+==========+ 
| default  | 192.168. | GOBGP    | S        | 65101    | establis | 3d:14h:3 | ipv4-uni | [100/100 | 
|          | 1.2      |          |          |          | hed      | 1m:41s   | cast     | /0]      | 
| default  | 192:168: | GOBGPv6  | S        | 65101    | establis | 3d:14h:3 | ipv6-uni | [100/100 |
|          | 1::2     |          |          |          | hed      | 1m:42s   | cast     | /0]      | 
+----------+----------+----------+----------+----------+----------+----------+----------+----------+ 
-----------------------------------------------------------------------------------------------------Summary:
2 configured neighbors, 2 configured sessions are established,0 disabled peers
0 dynamic peers
--{ running }--[  ]--
```
The image includes ipv4_rib.json & ipv6_rib.json which are internet routing table copies from April 2023, you can use pfx_parser.py to update the rib with a new copy as needed.