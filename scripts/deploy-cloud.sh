#!/bin/bash
#


BIN_PATH=$(cd "$(dirname "$0")"; pwd -P)
WORK_PATH=${BIN_PATH}/../


CONFIG_FILE=${WORK_PATH}/config.json
SECRETS_ENV=${WORK_PATH}/secrets.env

if [ ! -f ${SECRETS_ENV} ]; then
  echo 'missing secrets.env file'
  exit 1
fi

. ${SECRETS_ENV}

if [ ${CLOUD_PROVIDER} == "aws" ]; then
  jq -r 'del(.nodeSettings.cloudProvider.projectId)' ${CONFIG_FILE} > ${WORK_PATH}/config.local.json
fi


#${BIN_PATH}/airnode-deployer.sh deploy



