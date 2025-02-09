#!/bin/bash

VMID="$1"
SELECT="$2"
FIFO=/run/execute.fifo
touch /tmp/$VMID-running
echo "VM $VMID is $SELECT" >> $(dirname $0)/$VMID-hooks.log

cmd="$(dirname $0)/vm-proc.sh $VMID > /dev/null &"
echo $cmd >> $FIFO

echo "run monitor for proc exit"
