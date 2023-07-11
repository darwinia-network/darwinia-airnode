#!/bin/sh

set -e

BIN_PATH=$(cd "$(dirname "$0")"; pwd -P)
WORK_PATH=${BIN_PATH}/../

${BIN_PATH}/generate-config.sh

docker run --rm -it \
  --volume "${WORK_PATH}:/app/config" \
  --name quick-start-container-airnode \
  --network host \
  api3/airnode-client:0.11.2
