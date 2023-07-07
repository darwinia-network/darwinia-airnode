#!/bin/bash
#


BIN_PATH=$(cd "$(dirname "$0")"; pwd -P)


${BIN_PATH}/airnode-deployer.sh $1 remove-with-receipt



