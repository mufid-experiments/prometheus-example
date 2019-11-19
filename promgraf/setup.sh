#!/bin/bash

sudo ifconfig lo0 alias 192.168.46.49
sudo ifconfig lo:1      192.168.46.49 up
docker-compose up
