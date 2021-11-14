#!/bin/sh
echo 'start yum update'
yum update -y
echo 'update finished'
# ソースのシンボリックリンクを作成
echo 'add symlink to src'
ln -s /home/vagrant/src /var/www
echo 'symlink added'
# nginxのインストール、初期設定
echo '================================================================================'
echo '================================ install nginx ================================='
echo '================================================================================'
rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
yum install nginx -y
rm /etc/nginx/conf.d/default.conf
# nginx設定ファイル上書き
\cp -f /home/vagrant/provision/nginx.conf /etc/nginx/nginx.conf
systemctl enable nginx
systemctl start nginx
echo 'nginx installed'
echo '================================================================================'
echo '================================ install nodejs ================================'
echo '================================================================================'
curl -fsSL https://rpm.nodesource.com/setup_16.x | bash -
yum install -y nodejs
echo '================================================================================'
echo '================================ install php ==================================='
echo '================================================================================'
yum -y install epel-release
yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install --enablerepo=epel,remi,remi-php74 php php-devel php-mbstring php-pdo php-gd php-xml php-mcrypt php-fpm php-mysql php-mysqlnd
# php.ini上書き
\cp -f /home/vagrant/provision/php.ini /etc/php.ini
# php-fpm設定ファイル上書き
\cp -f /home/vagrant/provision/www.conf /etc/php-fpm.d/www.conf
systemctl enable php-fpm
systemctl start php-fpm
echo '================================================================================'
echo '================================ install redis ================================='
echo '================================================================================'
yum install -y redis
systemctl enable redis
systemctl start redis
echo '================================================================================'
echo '================================ install git ==================================='
echo '================================================================================'
yum -y install git
echo '================================================================================'
echo '================================ install zip ==================================='
echo '================================================================================'
yum -y install zip unzip
echo '================================================================================'
echo '============================== install composer ================================'
echo '================================================================================'
wget https://getcomposer.org/installer -O composer-installer.php
php composer-installer.php --filename=composer --install-dir=/usr/local/bin
composer config -g repos.packagist composer https://packagist.jp
composer config -g --unset repos.packagist
echo '================================================================================'
echo '================================ install MySql ================================='
echo '================================================================================'
# 競合の解決のためmariaDBのデータフォルダを削除する。
rm -rf /var/lib/mysql
# yumリポジトリの追加、インストール
yum install -y http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum install -y mysql-community-server
systemctl enable mysqld
systemctl start mysqld
# 初期パスワードを取得
IntPasswd=$(grep "A temporary password is generated for root@localhost:" /var/log/mysqld.log | awk '{ print $11}')
# パスワード指定
yum install -y expect
source ./provision.env
MysqlRootPasswd=$MYSQL_ROOT_PASSWD
expect -c '
    set timeout 10;
    spawn mysql_secure_installation;
    expect "Enter password for user root:";
    send -- "'"${IntPasswd}"'\n";
    expect "New password:";
    send -- "'"${MysqlRootPasswd}"'\n";
    expect "Re-enter new password:";
    send -- "'"${MysqlRootPasswd}"'\n";
    expect "Change the password for root ?";
    send "n\n";
    expect "Remove anonymous users?";
    send "y\n";
    expect "Disallow root login remotely?";
    send "y\n";
    expect "Remove test database and access to it?";
    send "y\n";
    expect "Reload privilege tables now?";
    send "y\n";
    interact;'