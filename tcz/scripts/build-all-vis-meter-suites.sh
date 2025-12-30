#!/usr/bin/env bash

set -euo pipefail
SCRIPT_PATH=$(dirname $(realpath $0))
BASE_PATH=$(dirname $(dirname ${SCRIPT_PATH}))
BUILD_PATH="${BASE_PATH}/build"
LOGS_PATH="${BUILD_PATH}/logs"
VISUALISERS_PATH="${BASE_PATH}/assets/visualisers"
SUITES_PATH="${BASE_PATH}/tcz/suites"

source ${SCRIPT_PATH}/util.sh

$SCRIPT_PATH/md5sum_pngs.sh

for f in ${SUITES_PATH}/vumeters/*
do
    echo "----- $f"
    if [ -f $f ] ;
    then
        build_tcz_suite $f "vumeters"
    fi
done

for f in ${SUITES_PATH}/spectrum/*
do
    echo "----- $f"
    if [ -f $f ] ;
    then
        build_tcz_suite $f "spectrum"
    fi
done
