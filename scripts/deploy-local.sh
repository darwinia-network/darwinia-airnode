#!/bin/sh

set -e

BIN_PATH=$(cd "$(dirname "$0")"; pwd -P)
WORK_PATH=${BIN_PATH}/../

${BIN_PATH}/generate-config.sh

CONTAINER_NAME=${1:-quick-start-container-airnode}

docker stop ${CONTAINER_NAME} || true
docker rm ${CONTAINER_NAME} || true
# You can specify port by replacing `--network=host` with `-p=<YOUR_PORT>:3000`
docker run -dit \
  --restart=always \
  --volume="${WORK_PATH}:/app/config" \
  --name=${CONTAINER_NAME} \
  --network=host \
  api3/airnode-client:0.12.0
