#!/usr/bin/env bash

rm -rf /tmp/vfio-sw

if [ -e "/home/sa" ]; then
    NIRI=$(systemctl --user -M sa@ status niri|grep -F active|grep -F running)
    if [ "$NIRI" ]; then
        systemctl --user -M sa@ stop niri
        echo "sa niri" >> /tmp/vfio-sw
    fi
fi