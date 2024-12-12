# pvevm-hooks

使用方法：

1、将pvevm-hooks、fifo两个文件夹上传至 /opt，如果是其它目录请修改 *.sh 脚本中引用脚本的路径
2、将 vm-hook.sh 复制到虚拟机某个存储的：snippets文件
3、设置虚拟机钩子脚本
	例如：qm set 100 -hookscript local:snippets/vm-hook.sh
4、将fifo/cmd.sh设置为开机自动启动，要以root账户运行
5、脚本里的vm-start.sh、vm-exit.sh等设置v_no等一定要是你的显卡的pci编号


#### 介绍

总体流程：
1、停止依赖设备驱动的软件、模块
2、将设备从驱动解绑
3、将设备加入VFIO给虚拟机
5、虚拟机使用设备
6、虚拟机关机
7、将设备从VFIO解绑
8、将设备分别加入原来的驱动
9、启动依赖设备驱动的软件恢复


### 下面是原始作者描述

PVE下KVM虚拟机直通钩子脚本<br>
本项目可以让PVE虚拟机直通的核显、声卡、USB控制器，在虚拟机关闭后返回PVE宿主机<br>
实现效果和详细操作说明请查看：<br>
B站视频：https://www.bilibili.com/video/BV1oT41137CU<br>
博客文章：https://zhing.fun/pve_igpupt/<br>


#### 使用说明

克隆本仓库至/root目录<br>
```
git clone https://gitee.com/hellozhing/pvevm-hooks.git
```
添加可执行权限<br>
```
cd pvevm-hooks
chmod a+x *.sh *.pl
```
脚本中默认没有启用USB直通返回，如需启用，请取消vm-stop.sh中“echo $usb_addr...”两行注释。<br>
复制perl脚本至snippets目录<br>
```
mkdir /var/lib/vz/snippets
cp hooks-igpupt.pl /var/lib/vz/snippets/hooks-igpupt.pl
```
将钩子脚本应用至虚拟机<br>
```
qm set <VMID> --hookscript local:snippets/hooks-igpupt.pl
```
<br>
如果PVE安装了图形界面<br>
请取消vm-start.sh中$(dirname $0)/vfio-startup.sh该行注释<br>
取消vm-stop.sh中$(dirname $0)/vfio-teardown.sh该行注释


#### 感谢
[@ledisthebest](https://gitee.com/ledisthebest)<br>
提供的脚本vfio-startup.sh和vfio-teardown.sh<br>
<br>


vfio-startup.sh
这个脚本是关闭所有依赖直通设备驱动的软件，在将设备从驱动解绑之前使用，不然会解绑失败

vfio-teardown.sh
这个脚本是将启动原来依赖直接设备的软件，在设备重新绑定驱后，不然不行
