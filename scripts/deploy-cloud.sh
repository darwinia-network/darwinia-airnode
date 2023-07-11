#!/bin/bash
#


BIN_PATH=$(cd "$(dirname "$0")"; pwd -P)

${BIN_PATH}/generate-config.sh

${BIN_PATH}/airnode-deployer.sh deploy



