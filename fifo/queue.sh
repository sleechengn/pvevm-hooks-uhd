#!/usr/bin/bash

FIFO=/run/execute.fifo

rm -rf $FIFO
rm -rf $(dirname $0)/logs

mkdir -p $(dirname $0)/logs
mkfifo $FIFO

while true;
do
	read command < $FIFO
	$command &
	echo "Command: $command executed." >> $(dirname $0)/logs/execute.log
done
