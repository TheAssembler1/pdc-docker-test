#!/usr/bin/env bash

set -xeu

echo "building base image"
sudo docker build --no-cache -t pdc-base -f base/Dockerfile .

echo "buliding and testing develop"
sudo docker build --no-cache -t pdc-develop-image -f develop/Dockerfile .
