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

3、（可选）可以建建立桌面图标，然后用我提供的.sh脚本来启动，请注意不能使用qm start vmid方法来启动虚拟机，因为启动的时候，会关闭GNOME，又由于你的启动脚本是在图形界面中执行的，会等待你的脚本执行结束，形成等待，所以一定要使用我的脚本启动

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
