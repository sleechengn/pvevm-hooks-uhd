#!/usr/bin/env bash

set -x

if systemctl status bluetooth > /dev/null 2>&1; then
    modprobe btusb
    sleep 1
    systemctl start bluetooth
fi