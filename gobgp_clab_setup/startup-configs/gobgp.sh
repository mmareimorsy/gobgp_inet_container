#!/bin/bash
ip add add 192.168.1.2/24 dev eth1
ip add add 192.168.2.2/24 dev eth2
ip -6 add add 192:168:1::2/112 dev eth1
ip -6 add add 192:168:2::2/112 dev eth2
