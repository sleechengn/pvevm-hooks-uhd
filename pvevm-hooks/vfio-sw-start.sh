#!/usr/bin/env bash

set -x

if systemctl status bluetooth > /dev/null 2>&1; then
    systemctl stop bluetooth
    sleep 1
    modprobe -r btusb
fi