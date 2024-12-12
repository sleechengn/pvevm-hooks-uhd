#!/usr/bin/bash
rm -rf /tmp/cmd2.fifo
mkfifo /tmp/cmd2.fifo

while true;
do
	read cmd < /tmp/cmd2.fifo
	echo "command: $cmd prepare execute." >> $(dirname $0)/cmd2.log
	$cmd
done
