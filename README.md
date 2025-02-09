已经应用于 8.3

本项目适用于Intel核显，并安装了GNOME桌面的PVE系统

使用效果：

虚拟机开机，GNOME桌面自动退出，开启虚拟机。虚拟机关机以后自动启动GNOME到桌面

安装GNOME桌面方法

```
	apt update
	tasksel
	#然后选择桌面和GNOME
```


开启虚拟机前自动关闭GDM等桌面服务，并将显卡绑定在vfio模块以供虚拟机使用

安装方法：

1、项目按目录结构放在 /opt 下,将所有的.sh文件设置为可执行，这个很重要

	操作方法是：进入目录执行 chmod +x *.sh

2、/opt/fifo下的 queue.sh 添加在 /etc/rc.local 自动启动中,没有这个文件就新建

	开启 /etc/rc.local 开机自动启动方法

  	使用  systemctl enable rc-local 命令启用开机启动 /etc/rc.local
	
  	新建	 /etc/rc.local ，在里面添加 /opt/fifo/queue.sh
```
#!/usr/bin/bash
/opt/fifo/queue.sh &   
```       
注意&符号非阻塞执行
```	
  	chmod +x /etc/rc.local #赋于执行权限
```	
  	重启电脑
   
3、直通显卡，并设置hook

	首先把 /opt/pvevm-hooks/vm-hook.sh 复制至 /var/lib/vz/snippets/	下，也就是local存储

  	将后在 /etc/pve/qemu-server/xxx.conf添加
```  	
hookscript: local:snippets/vm-hook.sh
```	

这样钩子设置完成，虚拟机启动、关闭、进程退出时就是执行这个脚本的内容

可以建建立桌面图标，然后用我提供的.sh脚本来启动

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
