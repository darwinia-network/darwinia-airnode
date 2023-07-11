#!/bin/bash
#


BIN_PATH=$(cd "$(dirname "$0")"; pwd -P)
WORK_PATH=${BIN_PATH}/../


CONFIG_EXAMPLE_FILE=${WORK_PATH}/config.json.example
CONFIG_TARGET_FILE=${WORK_PATH}/config.json
SECRETS_ENV=${WORK_PATH}/secrets.env

if [ ! -f ${SECRETS_ENV} ]; then
  echo 'missing secrets.env file'
  exit 1
fi

set -a; . ${SECRETS_ENV}; set +a

if [[ "${CLOUD_PROVIDER}" == "aws" ]]; then
  jq -r 'del(.nodeSettings.cloudProvider.projectId)' ${CONFIG_EXAMPLE_FILE} > ${CONFIG_TARGET_FILE}
else
  cp ${CONFIG_EXAMPLE_FILE} ${CONFIG_TARGET_FILE}
fi

env | while read -r line
do
  KEY=$(echo $line | cut -d '=' -f 1)
  VALUE=$(echo $line | cut -d '=' -f 2-)
  if [[ "${KEY}" == I_* ]]; then
    sed -i "s#\${${KEY}}#${VALUE}#g" ${CONFIG_TARGET_FILE}
  fi
done

sed -i -E "s/\\$\{I\_.*}//g" ${CONFIG_TARGET_FILE}


