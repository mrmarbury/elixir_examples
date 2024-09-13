#!/usr/bin/env bash

[ -z $1 ] && echo "Usage: $0 epmd -names port" && exit 1

ssh -p2022 -N -L $1:localhost:$1 -L 4369:localhost:4369 -L 9001:localhost:9001 root@localhost