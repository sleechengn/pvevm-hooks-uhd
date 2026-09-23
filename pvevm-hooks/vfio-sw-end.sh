#!/usr/bin/env bash

set -x

if systemctl status bluetooth > /dev/null 2>&1; then
    modprobe btusb
    sleep 1
    systemctl start bluetooth
fi

if id sa > /dev/null 2>&1; then
    if [ "$(systemctl --user -M sa@ is-active niri)" == "inactive" ]; then
        systemctl --user -M sa@ start niri
    fi
    if [ "$(systemctl --user -M sa@ is-active pipewire)" == "inactive" ]; then
        systemctl --user -M sa@ start pipewire
    fi
    if [ "$(systemctl --user -M sa@ is-active pipewire-pulse)" == "inactive" ]; then
        systemctl --user -M sa@ start pipewire-pulse
    fi
    if [ "$(systemctl --user -M sa@ is-active wireplumber)" == "inactive" ]; then
        systemctl --user -M sa@ start wireplumber
    fi
fi