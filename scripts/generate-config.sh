#!/bin/bash
#
set -e

BIN_PATH=$(cd "$(dirname "$0")"; pwd -P)
WORK_PATH=${BIN_PATH}/../

FILE_DEST_CONFIG_TEMPLATE=${WORK_PATH}/config.json.template
FILE_DEST_CONFIG_STORE=${WORK_PATH}/config.json
SECRETS_ENV=${WORK_PATH}/secrets.env

find_json_files(){
  for FILE in $(find ${WORK_PATH}/networks -type f -name "*.json"); do
    if [ -f $FILE ]; then
      echo $(basename "${FILE}" .json)
    fi
  done
}

INPUT_CHAINS=${@:-$(find_json_files)}


if [ ! -f ${SECRETS_ENV} ]; then
  echo 'missing secrets.env file'
  exit 1
fi

network_content() {
  CHAIN=$1
  TYPES='mainnet testnet'
  for TYPE in ${TYPES}; do
    FILE_PATH=${WORK_PATH}/networks/${TYPE}/${CHAIN}.json
    if [[ -f ${FILE_PATH} ]]; then
      cat ${FILE_PATH}
      exit 0
    fi
  done
}

handle_config() {
  cat ${FILE_DEST_CONFIG_TEMPLATE} > ${FILE_DEST_CONFIG_STORE}
  for CHAIN in ${INPUT_CHAINS}; do
    NETWORK_CONTENT=$(network_content ${CHAIN})
    NW_CHAIN=$(echo $NETWORK_CONTENT | jq '.chain')
    NW_RRP=$(echo $NETWORK_CONTENT | jq '.rrp')
    NW_HTTP=$(echo $NETWORK_CONTENT | jq '.http')
    NW_OIS=$(echo $NETWORK_CONTENT | jq '.ois')

    cat <<< $(jq ".chains += [${NW_CHAIN}]" ${FILE_DEST_CONFIG_STORE}) > ${FILE_DEST_CONFIG_STORE}
    cat <<< $(jq ".triggers.rrp += [${NW_RRP}]" ${FILE_DEST_CONFIG_STORE}) > ${FILE_DEST_CONFIG_STORE}
    cat <<< $(jq ".triggers.http += [${NW_HTTP}]" ${FILE_DEST_CONFIG_STORE}) > ${FILE_DEST_CONFIG_STORE}
    cat <<< $(jq ".ois += [${NW_OIS}]" ${FILE_DEST_CONFIG_STORE}) > ${FILE_DEST_CONFIG_STORE}
    echo "handle config for ${CHAIN}"
  done
}

handle_env() {
  set -a; . ${SECRETS_ENV}; set +a

  if [[ "${CLOUD_PROVIDER}" == "aws" ]]; then
    cat <<< $(jq -r 'del(.nodeSettings.cloudProvider.projectId)' ${FILE_DEST_CONFIG_STORE}) > ${FILE_DEST_CONFIG_STORE}
  fi

  if [[ "${CLOUD_PROVIDER}" == "local" ]]; then
    cat <<< $(jq -r 'del(
    .nodeSettings.cloudProvider.projectId,
    .nodeSettings.cloudProvider.region,
    .nodeSettings.cloudProvider.disableConcurrencyReservations
    )' ${FILE_DEST_CONFIG_STORE}) > ${FILE_DEST_CONFIG_STORE}
  fi

  echo "handle env"
}

main() {
  handle_config
  handle_env
  echo 'done'
}

main

