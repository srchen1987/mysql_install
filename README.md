
# mysql_install
本脚本在centos7 下运行 mysql安装包为glibc版
考虑下载过慢的情况 mysql安装包请自行下载
https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.16-linux-glibc2.12-x86_64.tar.xz

也可通过 wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.16-linux-glibc2.12-x86_64.tar.xz

将安装包解压到本脚本同级目录
xz -d mysql-8.0.16-linux-glibc2.12-x86_64.tar.xz
切换root 用户 执行 source install.sh 即可


安装过程中会提醒是否启动mysql服务，键入y 则启动。
过程中会生成mysql密码

   
	2019-05-27T10:25:32.625971Z 5 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: *,d!DuW=p3a:


my_template.cnf为模板文件 请根据实际情况进行调整

install.sh 中 MYSQL8="/usr/local/mysql8" 是安装的位置 这个可以自定义
