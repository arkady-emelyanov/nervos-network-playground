#!/usr/bin/env bash

if [[ -z "${CKB_CONFIG_PATH}" ]];
then
  echo "ERROR: Environment variable 'CKB_CONFIG_PATH' is not set!"
  exit 1
fi

SLEEP_TIME=${CKB_STARTUP_DELAY:-5}

echo "Sleeping for ${SLEEP_TIME} seconds..."
sleep ${SLEEP_TIME}
exec ckb miner -C ${CKB_CONFIG_PATH}
