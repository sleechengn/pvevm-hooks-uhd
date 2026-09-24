#!/usr/bin/env bash
set -x
if systemctl status bluetooth > /dev/null 2>&1; then
    modprobe btusb
    systemctl start bluetooth
fi
if id sa > /dev/null 2>&1; then
    if [ -e "/tmp/sa_services" ]; then
        while read serviceName; do
            echo "start $serviceName"
            systemctl --user -M sa@ start $serviceName
        done < "/tmp/sa_services"
    fi
fi