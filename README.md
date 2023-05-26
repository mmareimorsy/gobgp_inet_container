# gobgp_inet_container

This is a container that packages [GoBGP](https://github.com/osrg/gobgp/tree/master) together with [pfx_parser](https://github.com/mmareimorsy/pfx_parser) & [gobgp_inet_updater](https://github.com/mmareimorsy/gobgp_inet_updater), combined together this works as a way to have a BGP client with an internet routing table RIB for IPv4 & IPv6 that can be sent to networking devices under test.

The image can be used through docker

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
```

The image includes ipv4_rib.json & ipv6_rib.json which are internet routing table copies from April 2023, you can use pfx_parser.py to update the rib with a new copy as needed.