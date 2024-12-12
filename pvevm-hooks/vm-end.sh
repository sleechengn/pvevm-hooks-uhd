#!/bin/bash

VMID="$1"
SELECT="$2"

if [ -f "/tmp/$VMID-running"  ]; then
	rm -rf /tmp/$VMID-running
	echo "VM $VMID exit start "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log
	cmd="$(dirname $0)/vm-exit.sh $VMID $SELECT &"
	echo $cmd >> /tmp/cmd2.fifo
fi
