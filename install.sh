#/bin/base
yum -y install gcc gcc-c++ openssl openssl-devel libaio libaio-devel  ncurses  ncurses-deve
yum -y install numactl
mysql_file="mysql-8.0.16-linux-glibc2.12-x86_64"
if [ ! -d $mysql_file ];then
xz -d ${mysql_file}.tar.xz
tar -xvf ${mysql_file}.tar
fi

#set mysql home
MYSQL8="/usr/local/mysql8"
echo " installing mysql "

user=mysql
group=mysql

#create group if not exists
egrep "^$group" /etc/group >& /dev/null
if [ $? -ne 0 ]
then
	echo "add group $group"
    groupadd $group
fi

#create user if not exists
egrep "^$user" /etc/passwd >& /dev/null
if [ $? -ne 0 ]
then
	echo "add user $user"
    useradd -g $group $user
fi

if [ ! -d "$MYSQL8" ];then
mkdir -p $MYSQL8
fi

mv  -f $mysql_file/* $MYSQL8/
rm -rf $mysql_file
${MYSQL8}/bin/mysqld --initialize --user=mysql --basedir=${MYSQL8} --datadir=${MYSQL8}/data

#create data
if [ ! -d "$MYSQL8/data" ];then
mkdir $MYSQL8/data
fi

#create log
if [ ! -d "$MYSQL8/log" ];then
mkdir $MYSQL8/log
fi
touch $MYSQL8/log/mysql_err.log
chown -R mysql:mysql $MYSQL8/data $MYSQL8/log

which mysql > /dev/null
if [ ! $? -eq 0 ]
then
echo "export PATH=$PATH:$MYSQL8/bin"  >>  /etc/profile
source /etc/profile
fi

cp my_template.cnf my.cnf
sed -i "s#MYSQL8#$MYSQL8#g" my.cnf
if [ -e /etc/my.cnf ];then
cp /etc/my.cnf /etc/my.cnf.bak
echo "back up my.cnf to my.cnf.bak !"
fi

cp my.cnf /etc/my.cnf
cp  $MYSQL8/support-files/mysql.server  /etc/init.d/mysqld
sed -i "s#basedir=\$#basedir=$MYSQL8#g" /etc/init.d/mysqld

echo -n  "do you want to star mysql service now ? y or n ->"
read  input
if [[ $input == 'y' ]]; then
echo "start service"
/etc/init.d/mysqld start
else
 echo "mysql install complated"
fi
