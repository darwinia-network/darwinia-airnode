#!/bin/sh

BIN_PATH=$(cd "$(dirname "$0")"; pwd -P)
WORK_PATH=${BIN_PATH}/../

docker rm quick-start-container-airnode || true

docker run \
  --volume "${WORK_PATH}/$1:/app/config" \
  --name quick-start-container-airnode \
  --network host \
  api3/airnode-client-dev:0b7d89eb582d63aa299216f3cc28d82cf7071981
