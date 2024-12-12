#!/bin/bash

VMID="$1"
SELECT="$2"

echo "VM $VMID is $SELECT " > $(dirname $0)/$VMID-hooks.log

echo "VM Start 1"

v_no=$(lspci -nn -D|grep UHD|awk '{print $1}'|xargs -i lspci -s {} -n -D|awk '{print $1}')
v_id=$(lspci -nn -D|grep UHD|grep VGA|awk '{print $1}'|xargs -i lspci -s {} -n -D|awk '{print $3}')
v_id="$(echo $v_id|cut -c 1-4) $(echo $v_id|cut -c 6-9)"
v_dv=$(lspci -k -s $v_no|grep "Kernel driver in use"|awk '{print $5}')

a_no=$(lspci -nn -D|grep 8086|grep Audio|awk '{print $1}'|xargs -i lspci -s {} -n -D|awk '{print $1}')
a_id=$(lspci -nn -D|grep 8086|grep Audio|awk '{print $1}'|xargs -i lspci -s {} -n -D|awk '{print $3}')
a_id="$(echo $a_id|cut -c 1-4) $(echo $a_id|cut -c 6-9)"
a_dv=$(lspci -k -s $a_no|grep "Kernel driver in use"|awk '{print $5}')

echo "VM $VMID is starting prepare invoke vfio-startup.sh" >> $(dirname $0)/$VMID-hooks.log

echo "VM execute vfio-startup.sh"
$(dirname $0)/vfio-startup.sh

echo "ready to unbind $v_no to $v_dv"
echo "ready to unbind $v_no to $v_dv" >> $(dirname $0)/$VMID-hooks.log
echo $v_no > /sys/bus/pci/drivers/$v_dv/unbind
echo "[done] ready to unbind $v_no to $v_dv"


echo "modprobe vfio-pci"
if ! lsmod | grep "vfio_pci" &> /dev/null ; then
    modprobe vfio-pci
fi
echo "[done] modprobe vfio-pci"

echo "ready to bind $v_no to vfio" >> $(dirname $0)/$VMID-hooks.log
echo $v_id > /sys/bus/pci/drivers/vfio-pci/new_id


echo "Audio Unbind"
echo $a_no > /sys/bus/pci/drivers/$a_dv/unbind
if ! lsmod | grep "vfio_pci" &> /dev/null ; then
    modprobe vfio-pci
fi

echo "Remove $a_dv"
modprobe -r $a_dv

echo $a_id > /sys/bus/pci/drivers/vfio-pci/new_id
