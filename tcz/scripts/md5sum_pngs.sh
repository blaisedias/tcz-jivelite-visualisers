#!/usr/bin/env bash

set -euo pipefail
SCRIPT_PATH=$(dirname $(realpath $0))
BASE_PATH=$(dirname $(dirname ${SCRIPT_PATH}))
BUILD_PATH="${BASE_PATH}/build"
LOGS_PATH="${BUILD_PATH}/logs"
VISUALISERS_PATH="${BASE_PATH}/assets/visualisers"
SUITES_PATH="${BASE_PATH}/tcz/suites"


for f in ${VISUALISERS_PATH}/vumeters/*
do
    if [ -d "$f" ] && [ -f  "$f/meta.json" ] ;
    then
        for png in "${f}"/*.png
        do
            if [ -f "$png" ] ; then
                md5sum "$png" | sed "s# .*##" > "$png.md5sum"
            fi
        done
    fi
done

for f in ${VISUALISERS_PATH}/spectrum/*
do
    if [ -d "$f" ] && [ -f  "$f/meta.json" ] ;
    then
        for png in "${f}"/*.png
        do
            if [ -f "$png" ] ; then
                md5sum "$png" | sed "s# .*##" > "$png.md5sum"
            fi
        done
    fi
done
