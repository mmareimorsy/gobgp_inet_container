FROM ubuntu 
WORKDIR /root/gobgp/
RUN apt-get update -y 
RUN apt-get install iproute2 vim gobgpd python3 python3-pip -y
RUN apt-get install wget -y
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install ipaddress grpcio grpcio-tools mrtparse ijson
COPY ./gobgp_config.toml ./
COPY ./pfx_parser ./pfx_parser 
COPY ./gobgp_inet_updater ./gobgp_inet_updater
COPY ./ipv4_rib.json ./
COPY ./ipv6_rib.json ./
RUN ln -s /root/gobgp/pfx_parser/pfx_parser.py /usr/bin/
RUN ln -s /root/gobgp/gobgp_inet_updater/gobgp_client.py /usr/bin/