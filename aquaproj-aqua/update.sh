#!/bin/bash
set -eu
AQUA_DIR="$(dirname $AQUA_GLOBAL_CONFIG)"
cd $AQUA_DIR
set +e
log=$AQUA_DIR/log.txt
#exec &> >(awk '{print strftime("[%Y/%m/%d %H:%M:%S] "),$0 } { fflush() } ' >> $log)
aqua i -a -l 2>&1 | tee -a $log
aqua upa 2>&1 | tee -a $log
