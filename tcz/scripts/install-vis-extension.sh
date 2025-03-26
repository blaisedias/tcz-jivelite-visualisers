#!/bin/sh
set -euo pipefail
if [ -f "/usr/local/etc/pcp/pcpversion.cfg" ] ; 
then
    TCEMNT="/mnt/$(readlink /etc/sysconfig/tcedir | cut -d '/' -f3)"
    TCEDIR="${TCEMNT}/tce"

    set -x

    if [ -f "$1" ] && [ -f "${1}.md5.txt" ] ;
    then
       cp "${1}" "$TCEDIR/optional/"
       cp "${1}.md5.txt" "$TCEDIR/optional/"
       tczname=$(basename "$1")
       sed -i "$TCEDIR/onboot.lst" -e "/${tczname}\$/d"
       echo "${tczname}" >> "${TCEDIR}/onboot.lst"
       tce-load -i "${1}"
    fi
else
    echo "This script must be run on piCorePlayer"
fi
