#!/usr/bin/bash

VMID=$1
SELECT=$2

if [ $SELECT == "pre-start" ]; then
	echo "pre-start-start"
	$(dirname $0)/vm-start.sh $VMID $SELECT
fi

if [ $SELECT == "post-start" ]; then
	echo "post-start-start"
        $(dirname $0)/vm-run.sh $VMID $SELECT
fi

if [ $SELECT == "pre-stop" ]; then
        echo "pre-stop-start"
        $(dirname $0)/vm-pre-stop.sh $VMID $SELECT
fi

if [ $SELECT == "post-stop" ]; then
	echo "post-stop-start"
        $(dirname $0)/vm-stop.sh $VMID $SELECT
fi
