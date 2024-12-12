#!/usr/bin/bash

#start sub daemon
$(dirname $0)/cmd1.sh &
$(dirname $0)/cmd2.sh &

rm -rf /tmp/cmd.fifo
mkfifo /tmp/cmd.fifo

while true;
do
	read cmd < /tmp/cmd.fifo
	echo "command: $cmd prepare execute." >> $(dirname $0)/cmd.log
	$cmd
done
