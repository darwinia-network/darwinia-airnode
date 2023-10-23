#!/bin/sh

set -e

BIN_PATH=$(cd "$(dirname "$0")"; pwd -P)
WORK_PATH=${BIN_PATH}/../

${BIN_PATH}/generate-config.sh

CONTAINER_NAME=${1:-quick-start-container-airnode}

docker stop ${CONTAINER_NAME} || true
docker rm ${CONTAINER_NAME} || true
docker run -dit \
  --restart=always \
  --volume="${WORK_PATH}:/app/config" \
  --name=${CONTAINER_NAME} \
  -p=3000:3000 \
  api3/airnode-client:0.12.0
