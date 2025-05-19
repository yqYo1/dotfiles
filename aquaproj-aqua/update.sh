#!/bin/env bash
set -eu
export GITHUB_TOKEN="$(gh auth token)"
AQUA_DIR="$(dirname $AQUA_GLOBAL_CONFIG)"
cd $AQUA_DIR
set +e
log="$AQUA_DIR/log.txt"
aqua i -a 2>&1 | tee -a $log
aqua upa 2>&1 | tee -a $log
