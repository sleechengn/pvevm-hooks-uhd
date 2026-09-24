#!/usr/bin/env bash

set -x

if systemctl status bluetooth > /dev/null 2>&1; then
    systemctl stop bluetooth
    modprobe -r btusb
fi

rm -rf /tmp/sa_services

if id sa > /dev/null 2>&1; then
    if systemctl --user -M sa@ status niri > /dev/null 2>&1; then
        systemctl --user -M sa@ stop niri
        echo "niri" >> /tmp/sa_services
    fi
    if systemctl --user -M sa@ status pipewire > /dev/null 2>&1; then
        systemctl --user -M sa@ stop pipewire
        echo "pipewire" >> /tmp/sa_services
    fi
    if systemctl --user -M sa@ status pipewire-pulse > /dev/null 2>&1; then
        systemctl --user -M sa@ stop pipewire-pulse
        echo "pipewire-pulse" >> /tmp/sa_services
    fi
    if systemctl --user -M sa@ status  > /dev/null 2>&1; then
        systemctl --user -M sa@ stop wireplumber
        echo "wireplumber" >> /tmp/sa_services
    fi
fi