#!/bin/sh

set -euo pipefail

SCRIPTDIR=$(dirname $(realpath $0))

if [ -f "/usr/local/etc/pcp/pcpversion.cfg" ] ; 
then

    tce-load -w bash
    tce-load -w git
    tce-load -w squashfs-tools

    tce-load -il bash
    tce-load -il git
    tce-load -il squashfs-tools

    $SCRIPTDIR/build-vis-meter-suites.sh
else
    echo "This script must be run on piCorePlayer"
fi
