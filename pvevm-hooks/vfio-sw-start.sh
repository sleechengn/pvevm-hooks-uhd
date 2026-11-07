#!/usr/bin/env bash
set -x
if systemctl status bluetooth > /dev/null 2>&1; then
    systemctl stop bluetooth
    modprobe -r btusb
fi

rm -rf /tmp/services
function shutdown_service {
    ServiceName=$1
    if systemctl status $ServiceName > /dev/null 2>&1; then
        systemctl stop $ServiceName
        echo "$ServiceName" >> /tmp/services
    fi
}

shutdown_service greetd

if id -u sa > /dev/null 2>&1; then
    rm -rf /tmp/sa_services
    function shutdown_usrservice {
        ServiceName=$1
        UserName=$2
        if systemctl --user -M $UserName@ status $ServiceName > /dev/null 2>&1; then
            systemctl --user -M $UserName@ stop $ServiceName
            echo "$ServiceName" >> /tmp/sa_services
        fi
    }
    if id -u sa > /dev/null 2>&1; then
        shutdown_usrservice niri sa
        shutdown_usrservice pipewire sa
        shutdown_usrservice pipewire-pulse sa
        shutdown_usrservice wireplumber sa
    fi
fi