#!/usr/bin/env bash

if [ -e "/tmp/vfio-sw" ]; then
    while IFS=" " read -r un sn; do
        echo un=$un sn=$sn
        if [ "$un" == "sa" ] && [ "$sn" == "niri" ]; then
            echo "start $sn@$un"
            systemctl --user -M $un@ $sn
        fi
    done < "/tmp/vfio-sw"
fi