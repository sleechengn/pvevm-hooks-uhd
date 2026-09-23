#!/usr/bin/env bash

set -x

if systemctl status bluetooth > /dev/null 2>&1; then
    modprobe btusb
    sleep 1
    systemctl start bluetooth
fi

if id sa > /dev/null 2>&1; then
    if systemctl --user -M sa@ status niri > /dev/null 2>&1; then
        systemctl --user -M sa@ start niri
    fi
    if systemctl --user -M sa@ status pipewire > /dev/null 2>&1; then
        systemctl --user -M sa@ start pipewire
    fi
    if systemctl --user -M sa@ status pipewire-pulse > /dev/null 2>&1; then
        systemctl --user -M sa@ start pipewire-pulse
    fi
    if systemctl --user -M sa@ status wireplumber > /dev/null 2>&1; then
        systemctl --user -M sa@ start wireplumber
    fi
fi