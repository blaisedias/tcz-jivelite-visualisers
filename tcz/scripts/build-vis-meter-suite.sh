#!/usr/bin/env bash

if [ -f "$1" ] ; then
    if [ "$2" == "vumeters" ] || [ "$2" == "spectrum" ] ;
    then
        :
    else
        echo "Usage $0 <path-to-suitefile> <vumeters|spectrum>"
        exit 1
    fi
else
    echo "Usage $0 <path-to-suitefile> <vumeters|spectrum>"
    exit 1
fi

set -euo pipefail
SCRIPT_PATH=$(dirname $(realpath $0))
BASE_PATH=$(dirname $(dirname ${SCRIPT_PATH}))
BUILD_PATH="${BASE_PATH}/build"
LOGS_PATH="${BUILD_PATH}/logs"
VISUALISERS_PATH="${BASE_PATH}/assets/visualisers"
SUITES_PATH="${BASE_PATH}/tcz/suites"

source ${SCRIPT_PATH}/util.sh

if [ -f "$1" ] ; then
    if [ "$2" == "vumeters" ] || [ "$2" == "spectrum" ] ;
    then
        build_tcz_suite "$1" "$2"
    else
        echo "Usage $0 <spath-to-suitefile> <vumeters|spectrum>"
    fi
fi
