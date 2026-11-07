#!/usr/bin/env bash
set -x
if systemctl status bluetooth > /dev/null 2>&1; then
    modprobe btusb
    systemctl start bluetooth
fi

if [ -e "/tmp/services" ]; then
    while read serviceName; do
        echo "start $serviceName"
        systemctl start $serviceName
    done < "/tmp/services"
fi

if id -u sa > /dev/null 2>&1; then
    if [ -e "/tmp/sa_services" ]; then
        while read serviceName; do
            echo "start $serviceName"
            systemctl --user -M sa@ start $serviceName
        done < "/tmp/sa_services"
    fi
fi