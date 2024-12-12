#!/bin/bash
VMID="$1"
SELECT="$2"
echo "pre stop event start,VM $VMID status $SELECT "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log

if [ -f "/tmp/$VMID-running"  ]; then
	echo "running file exist waiting stop event "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log
else
	echo "running file not exist run vm-exit "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log
	cmd="$(dirname $0)/vm-exit.sh $VMID post-stop"
	echo $cmd >> /tmp/cmd1.fifo
fi
