#!/usr/bin/env bash
set -xeu

echo "building base image"
sudo docker build -t pdc-base -f base/Dockerfile .

echo "building images"
sudo docker build -t pdc-develop-image -f develop/Dockerfile .
sudo docker build -t pdc-stable-image -f stable/Dockerfile .

trap 'echo "Interrupted. Killing background processes."; kill $PID_DEV $PID_STABLE 2>/dev/null || true' SIGINT SIGTERM

echo "running images"
sudo docker run --rm pdc-develop-image | sed 's/^/[DEVELOP] /' &
PID_DEV=$!

sudo docker run --rm pdc-stable-image | sed 's/^/[STABLE] /' &
PID_STABLE=$!

wait $PID_DEV
wait $PID_STABLE

echo "Both develop and stable runs completed."

