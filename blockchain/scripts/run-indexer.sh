#!/usr/bin/env bash

STORAGE_PATH=${CKB_STORAGE_PATH:-/data}
SLEEP_TIME=${CKB_STARTUP_DELAY:-5}
NODE_URL=${API_URL:-http://127.0.0.1:8114}
LISTEN_ADDRESS=${CKB_LISTEN_ADDRESS:-0.0.0.0:8116}

echo "Sleeping for ${SLEEP_TIME} seconds..."
sleep ${SLEEP_TIME}

export RUST_LOG=info
exec ckb-indexer -c ${NODE_URL} -s ${STORAGE_PATH} -l ${LISTEN_ADDRESS}
