#!/usr/bin/bash

VMID=$1
SELECT=$2

if [ $SELECT == "pre-start" ]; then
	echo "pre-start-start"
	/opt/pvevm-hooks/vm-start.sh $VMID $SELECT
fi

if [ $SELECT == "post-start" ]; then
	echo "post-start-start"
        /opt/pvevm-hooks/vm-run.sh $VMID $SELECT
fi

if [ $SELECT == "pre-stop" ]; then
        echo "pre-stop-start"
        /opt/pvevm-hooks/vm-pre-stop.sh $VMID $SELECT
fi

if [ $SELECT == "post-stop" ]; then
	echo "post-stop-start"
        /opt/pvevm-hooks/vm-stop.sh $VMID $SELECT
fi
