已经应用于 8.x,9.x

本项目适用于Intel核显，并适用安装了GNOME桌面的PVE系统，也可以适用未安装图形界面的PVE

使用本项目，不需要在禁用i915、snd_intel等模块，本项目会自动解绑这些设备在主机上的占用

使用效果：

虚拟机开机，GNOME桌面自动退出，或者SHELL界面退出，开启虚拟机，显卡由虚拟机占用。虚拟机关机以后自动启动GNOME到桌面，或者SHELL

1、（可选）如果要安装GNOME可以使用以下的方法

安装GNOME桌面方法

```
	apt update
	tasksel
	#然后选择桌面和GNOME
```

2、钩子安装方法

```
	git clone https://github.com/sleechengn/pvevm-hooks-uhd
	cd pvevm-hooks-uhd
	chmod +x install-hook.sh
	./install-hook <vmid>
	# <vmid> 写成你的虚拟机id
```

这样钩子设置完成，虚拟机启动、关闭、进程退出时就是执行这个脚本的内容

3、（可选）可以建建立桌面图标，然后用我提供的.sh脚本来启动，请注意不能使用qm start vmid方法来启动虚拟机，因为启动的时候，会关闭GNOME，又由于你的启动脚本是在图形界面中执行的，会等待你的脚本执行结束，形成死锁等待，所以在GNOME下一定要使用我的脚本启动，如果未安装图形，用qm start启动虚拟机

vm-start.sh

```
#!/usr/bin/bash

#VM ID
VMID=$1

#认证密码，此处改成你的密码
AUTH_PASSWORD="yourpassword"

#通过账号密码获取票据和凭证
auth_json=$(curl --silent --insecure --data "username=root@pam&password=$AUTH_PASSWORD"  https://localhost:8006/api2/json/access/ticket)
#提取JSON中的票据
ticket=$(echo $auth_json | jq --raw-output '.data.ticket')
#提取JSON中的凭证
csrf_token=$(echo $auth_json | jq --raw-output '.data.CSRFPreventionToken')

#用curl通过票据和凭证调用开机api
curl -k -v -X POST -b "PVEAuthCookie=$ticket" -H "CSRFPreventionToken: $csrf_token" https://localhost:8006/api2/json/nodes/pve/qemu/$VMID/status/start
```




启动方法

```
vm-start.sh xxxVMID
```
### 如果你要使用Q35直通，请安装以下包

PVE9 请安装 [pve-qemu-kvm](https://github.com/sleechengn/pvevm-hooks-uhd/releases) 定制直通包，不然Q35无法BIOS输出，最高版本安装

核显直通配置：

i440fx 参考
```
agent: 1
args: -set device.hostpci0.addr=02.0 -set device.hostpci0.x-igd-gms=0x2 -set device.hostpci0.x-igd-opregion=on -set device.hostpci0.x-igd-legacy-mode=on
balloon: 0
bios: ovmf
boot: order=virtio0;net0
cores: 6
cpu: host
efidisk0: hdd:112/vm-112-disk-3.qcow2,efitype=4m,size=528K
hookscript: local:snippets/pvevm-hooks-uhd.sh
hostpci0: 0000:00:02.0,romfile=vbios/z370.rom
hostpci1: 0000:00:1f.3
machine: pc-i440fx-10.0
memory: 8192
meta: creation-qemu=10.0.2,ctime=1755647865
name: wini440fx-igd
net0: virtio=BC:24:11:08:94:47,bridge=lan
numa: 0
ostype: win11
scsihw: virtio-scsi-single
smbios1: uuid=77317aed-9416-4cde-b9ec-b705b6d1ce52
sockets: 1
tpmstate0: hdd:112/vm-112-disk-4.raw,size=4M,version=v2.0
usb0: mapping=USB-KB
usb1: mapping=USB-MOUSE
usb2: mapping=AX210-USB-BT
vga: none
virtio0: nvme:112/vm-112-disk-0.qcow2,iothread=1,size=64G
vmgenid: 5dc9d0cb-d91f-4c75-80d2-6465edcd9342
```

q35 参考
```
agent: 1
args: -set device.hostpci0.bus=pcie.0 -set device.hostpci0.addr=0x02.0 -set device.hostpci0.x-igd-gms=0x2 -set device.hostpci0.x-igd-opregion=on -set device.hostpci0.x-igd-lpc=on
balloon: 0
bios: ovmf
boot: order=virtio0
cores: 6
cpu: host
efidisk0: hdd:103/base-103-disk-0.qcow2/100/vm-100-disk-0.qcow2,efitype=4m,pre-enrolled-keys=1,size=528K
hookscript: local:snippets/pvevm-hooks-uhd.sh
hostpci0: 0000:00:02.0,pcie=1,romfile=vbios/z370.rom,x-vga=1
hostpci1: 0000:00:1f.3,pcie=1
hostpci2: 0000:06:00.0,pcie=1,romfile=vbios/AD106.rom
hostpci3: 0000:06:00.1,pcie=1
machine: pc-q35-10.0
memory: 32768
meta: creation-qemu=10.0.2,ctime=1754921457
name: AD106.win11-igd
net0: virtio=BC:24:11:93:7F:B5,bridge=lan
numa: 0
ostype: win11
scsihw: virtio-scsi-single
smbios1: uuid=0b5d690c-5894-4a17-ace7-52f48840fc71
sockets: 1
tpmstate0: hdd:100/vm-100-disk-1.raw,size=4M,version=v2.0
usb0: mapping=USB-KB
usb1: mapping=USB-MOUSE
usb2: mapping=AX210-USB-BT
vga: none
virtio0: nvme:103/base-103-disk-0.qcow2/100/vm-100-disk-0.qcow2,iothread=1,size=128G
virtio1: hdd:100/vm-100-disk-2.qcow2,iothread=1,size=1T
vmgenid: 8e593b84-b894-4461-8d7e-0bf05929a9a6
```

注意你的ROM文件，可以自己制作，也可以去 https://github.com/LongQT-sea/intel-igpu-passthru 下载

笔记本键盘，要直通，可以参考
```
-object input-linux,id=kbd,evdev=/dev/input/by-path/platform-i8042-serio-0-event-kbd,grab_all=on,repeat=on
-object input-linux,id=mouse1,evdev=/dev/input/by-path/pci-0000\:00\:15.0-platform-i2c_designware.0-event-mouse
```
