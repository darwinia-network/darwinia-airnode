#!/bin/bash
#
set -e

BIN_PATH=$(cd "$(dirname "$0")"; pwd -P)

${BIN_PATH}/generate-config.js

${BIN_PATH}/airnode-deployer.sh deploy



