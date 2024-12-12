#!/bin/bash
VMID="$1"
SELECT="$2"

echo "stop event start,VM $VMID status $SELECT "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log

cmd="$(dirname $0)/vm-end.sh $VMID $SELECT"

echo $cmd >> /tmp/cmd1.fifo
