#!/usr/bin/bash
rm -rf /tmp/cmd1.fifo
mkfifo /tmp/cmd1.fifo

while true;
do
	read cmd < /tmp/cmd1.fifo
	echo "command: $cmd prepare execute." >> $(dirname $0)/cmd1.log
	$cmd
done
