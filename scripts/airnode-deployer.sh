#!/bin/bash
#
set -e

BIN_PATH=$(cd "$(dirname "$0")"; pwd -P)
WORK_PATH=${BIN_PATH}/../

docker run -it --rm \
  -v "${WORK_PATH}:/app/config" \
  api3/airnode-deployer:0.11.2 \
  $@


