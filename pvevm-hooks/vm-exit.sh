#!/bin/bash

VMID="$1"
SELECT="$2"

echo "VM $VMID is exiting" >> $(dirname $0)/$VMID-hooks.log

v_no=$(lspci -nn -D|grep 8086|grep UHD|awk '{print $1}'|xargs -i lspci -s {} -n -D|awk '{print $1}')
v_id=$(lspci -nn -D|grep 8086|grep UHD|awk '{print $1}'|xargs -i lspci -s {} -n -D|awk '{print $3}')
v_id="$(echo $v_id|cut -c 1-4) $(echo $v_id|cut -c 6-9)"
v_dv="i915"

a_no=$(lspci -nn -D|grep 8086|grep Audio|awk '{print $1}'|xargs -i lspci -s {} -n -D|awk '{print $1}')
a_id=$(lspci -nn -D|grep 8086|grep Audio|awk '{print $1}'|xargs -i lspci -s {} -n -D|awk '{print $3}')
a_id="$(echo $a_id|cut -c 1-4) $(echo $a_id|cut -c 6-9)"
a_dv="snd_hda_intel"

echo "unbind $v_no from vfio-pci "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log
echo $v_no > /sys/bus/pci/drivers/vfio-pci/unbind

echo "remove $v_id from vfio-pci "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log
echo $v_id > /sys/bus/pci/drivers/vfio-pci/remove_id

echo "unbind $a_no from vfio-pci "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log
echo $a_no > /sys/bus/pci/drivers/vfio-pci/unbind

echo "remove $a_id from vfio-pci "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log
echo $a_id > /sys/bus/pci/drivers/vfio-pci/remove_id

echo "load mod i915 "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log
modprobe $v_dv
modprobe $a_dv

echo "bind $v_no to $v_dv "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log
echo $v_no > /sys/bus/pci/drivers/$v_dv/bind

echo "bind $a_no to $a_dv "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log
echo $a_no > /sys/bus/pci/drivers/$a_dv/bind

echo "vfio-teardown start "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log
$(dirname $0)/vfio-teardown.sh

echo "VM $VMID stopped "$(date "+%Y-%m-%d %H:%M:%S") >> $(dirname $0)/$VMID-hooks.log
