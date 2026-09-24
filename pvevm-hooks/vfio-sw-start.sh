#!/usr/bin/env bash
set -x
if systemctl status bluetooth > /dev/null 2>&1; then
    systemctl stop bluetooth
    modprobe -r btusb
fi
rm -rf /tmp/sa_services
function shutdown_service {
    ServiceName=$1
    if systemctl --user -M sa@ status $ServiceName > /dev/null 2>&1; then
        systemctl --user -M sa@ stop $ServiceName
        echo "$ServiceName" >> /tmp/sa_services
    fi
}
if id sa > /dev/null 2>&1; then
    shutdown_service niri
    shutdown_service pipewire
    shutdown_service pipewire-pulse
    shutdown_service wireplumber
fi