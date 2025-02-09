#!/bin/bash
VMID="$1"
echo "VM $VMID monitor Running" >> $(dirname $0)/$VMID-hooks.log
vmxPID=$(cat /var/run/qemu-server/$VMID.pid)
tail --pid=$vmxPID -f /dev/null
stat="post-stop"
echo "VM $VMID proc is exit" $(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log
$(dirname $0)/vm-stop.sh $VMID $stat
