#!/usr/bin/env bash

set -x

if systemctl status bluetooth > /dev/null 2>&1; then
    systemctl stop bluetooth
    sleep 1
    modprobe -r btusb
fi

if id sa > /dev/null 2>&1; then
    if systemctl --user -M sa@ status pipewire > /dev/null 2>&1; then
        systemctl --user -M sa@ stop pipewire
    fi
    if systemctl --user -M sa@ status pipewire-pulse > /dev/null 2>&1; then
        systemctl --user -M sa@ stop pipewire-pulse
    fi
    if systemctl --user -M sa@ status wireplumber > /dev/null 2>&1; then
        systemctl --user -M sa@ stop wireplumber
    fi
fi