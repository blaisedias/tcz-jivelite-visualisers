#!/usr/bin/env bash
usage="Usage $0 <path-to-visualiser> <author> <copying-policy>"

if [ -d "$1" ] ; then
    vistype=$(basename $(dirname "$1"))
    if [ "$vistype" == "vumeters" ] || [ "$vistype" == "spectrum" ] ;
    then
        if [ "$2" == "" ] || [ "$3" == "" ] ;
        then
            echo $usage
            exit 1
        fi
    else
        echo $usage
        exit 1
    fi
else
    echo $usage
    exit 1
fi

set -euo pipefail
SCRIPT_PATH=$(dirname $(realpath $0))
BASE_PATH=$(dirname $(dirname ${SCRIPT_PATH}))
BUILD_PATH="${BASE_PATH}/build"
LOGS_PATH="${BUILD_PATH}/logs"
VISUALISERS_PATH="${BASE_PATH}/assets/visualisers"

    tcz_name=$(basename "$1")
    if [ "$vistype" == "vumeters" ] && [ -f "$1/meta.json" ] ;
    then
        tcz_name="VU_Meter_vis_${tcz_name}"
    elif [ "$vistype" == "spectrum" ] && [ -f "$1/meta.json" ] ;
    then
        tcz_name="SP_Meter_vis_${tcz_name}"
    else
        echo "missing meta.json file?"
        exit 2
    fi

    tcz_name="vis-${tcz_name}"
    echo "tcz=$tcz_name"
    dstdir="${BUILD_PATH}/${tcz_name}/opt/jivelite/assets/visualisers/$2/"
    rm -rf "${dstdir}"
    mkdir -p "${dstdir}"
    mkdir -p ${LOGS_PATH}

    declare -A info_array
    info_array["Title:"]="${tcz_name}.tcz"
    info_array["Description:"]="Community squeezebox controller 3rd party VU image."
    info_array["Version:"]="8.0.0"
    info_array["Commit:"]="-"
    info_array["Author:"]="$2"
    info_array["Original-site:"]="https://forums.lyrion.org"
    info_array["Copying-policy:"]="$3"
    info_array["Size:"]="-"
    info_array["Extension_by:"]="piCorePlayer team: https://www.picoreplayer.org/"


    cp -aR "${1}" "${dstdir}"

    rm -f "${BUILD_PATH}/${tcz_name}.tcz*"
    cd "${BUILD_PATH}"
    pwd
    mksquashfs "${tcz_name}/" "${tcz_name}.tcz" -b 16384 -info >& "${LOGS_PATH}/${tcz_name}.log" && md5sum "${tcz_name}.tcz" > "${tcz_name}.tcz.md5.txt"
    echo "created ${PWD}/${tcz_name}.tcz"
    echo "log file is ${PWD}/logs/${tcz_name}.log"
    cd "${BUILD_PATH}/${tcz_name}"
    find opt -type f > "${BUILD_PATH}/${tcz_name}.list"
    cd "${BUILD_PATH}"
    rm -rf ${tcz_name}
    echo "BOGUS.tcz" > "${tcz_name}.dep.tcz"
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
    cd "${SCRIPT_PATH}"
