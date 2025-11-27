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

function build_tcz_suite {
    suite_definition="$1"
    tcz_name=$(basename $1)
    echo "tcz=$tcz_name"
    dstdir="${BUILD_PATH}/${tcz_name}/opt/jivelite/assets/visualisers/$2/"
    rm -rf ${dstdir}
    mkdir -p ${dstdir}
    mkdir -p ${LOGS_PATH}

    declare -A info_array
    info_array["Title:"]="${tcz_name}.tcz"
    info_array["Description:"]="Community squeezebox controller 3rd party VU image."
    info_array["Version:"]="8.0.0"
    info_array["Commit:"]="-"
    info_array["Author:"]="-"
    info_array["Original-site:"]="https://forums.lyrion.org"
    info_array["Copying-policy:"]="Public Domain"
    info_array["Size:"]="-"
    info_array["Extension_by:"]="piCorePlayer team: https://www.picoreplayer.org/"


    while IFS= read -r line
    do
        if [ -d "${VISUALISERS_PATH}/${line}" ] ;
        then 
            echo "    adding ${line}"
            cp -aR "${VISUALISERS_PATH}/${line}" ${dstdir}
        else
            meta_key=$(echo "${line}" | awk '{print $1}')
            meta_value=$(echo "${line}" | sed -e 's/^.*:\s*//')
            info_array["${meta_key}"]="${meta_value}"
        fi
    done < ${suite_definition}

    rm -f "${BUILD_PATH}/${tcz_name}.tcz*"
    cd ${BUILD_PATH}
    pwd
    mksquashfs "${tcz_name}/" "${tcz_name}.tcz" -b 16384 -info >& "${LOGS_PATH}/${tcz_name}.log" && md5sum "${tcz_name}.tcz" > "${tcz_name}.tcz.md5.txt"
    echo "created ${PWD}/${tcz_name}.tcz"
    echo "log file is ${PWD}/logs/${tcz_name}.log"
    cd "${BUILD_PATH}/${tcz_name}"
    find opt -type f > "${BUILD_PATH}/${tcz_name}.list"
    cd ${BUILD_PATH} 
    rm -rf ${tcz_name}
    echo "BOGUS.tcz" > ${tcz_name}.dep
    size=$(ls -l "${tcz_name}.tcz" | awk '{print $5}')
    info_array["Size:"]="$size"
    rm -f "${tcz_name}.tcz.info"
#    for elem in "${!info_array[@]}"
#    do
#        echo "${elem}		${info_array[${elem}]}" >> "${tcz_name}.tcz.info"
#    done
#
    for elem in "Title:" "Description:" "Version:" "Commit:" "Author:" "Original-site:" "Copying-policy:" "Size:" "Extension_by:"
    do
        echo "${elem}		${info_array[${elem}]}" >> "${tcz_name}.tcz.info"
    done
    cd ${SCRIPT_PATH} 
}

if [ -f "$1" ] ; then
    if [ "$2" == "vumeters" ] || [ "$2" == "spectrum" ] ;
    then
        build_tcz_suite "$1" "$2"
    else
        echo "Usage $0 <spath-to-suitefile> <vumeters|spectrum>"
    fi
fi
