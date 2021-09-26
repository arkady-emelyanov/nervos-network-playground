#!/usr/bin/env bash

if [[ -z "${CKB_CONFIG_PATH}" ]];
then
  echo "ERROR: Environment variable 'CKB_CONFIG_PATH' is not set!"
  exit 1
fi

sleep ${CKB_STARTUP_DELAY:-0}
exec ckb run -C ${CKB_CONFIG_PATH}
