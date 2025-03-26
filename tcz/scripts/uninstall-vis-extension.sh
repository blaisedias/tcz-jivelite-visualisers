#!/bin/sh
set -euo pipefail
if [ -f "/usr/local/etc/pcp/pcpversion.cfg" ] ; 
then
    TCEMNT="/mnt/$(readlink /etc/sysconfig/tcedir | cut -d '/' -f3)"
    TCEDIR="${TCEMNT}/tce"

    set -x
    if [ -f "$1" ] && [ -f "${1}.md5.txt" ] ;
    then
        tczname=$(basename "$1")
        sed -i "$TCEDIR/onboot.lst" -e "/${tczname}\$/d"
        sudo rm -f "$TCEDIR/optional/${tczname}"
        sudo rm -f "$TCEDIR/optional/${tczname}.md5.txt"
    fi
else
    echo "This script must be run on piCorePlayer"
fi
