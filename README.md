## 简介
适用于 Ubuntu14.04/16.04 的 LNMP 安装脚本

请在 root 用户下执行该脚本，如果登录账户不是 root，则需要执行 `sudo su root` 切换为 root 账户后再下载安装

## 软件列表
* Git
* Redis
* Nginx
* PHP7.2.5
* Composer
* MySQL5.7

## 注意
* 将系统的源更换为国内源再安装，不然在初始化软件仓库和下载软件包会非常非常慢
* 用命令`sudo apt-get -f install`复损坏的软件包，尝试卸载出错的包，重新安装正确的版本，然后再执行命令`sudo apt-get upgrade`更新软件包
* 该脚本采用的是源码安装PHP7.2.5的方式，所以在下载和编译过程的时间会稍微长一些，另外，MySQL5.7在下载过程也会消耗比较多的时间
 
## 安装
执行命令 `wget -qO- https://raw.githubusercontent.com/Treehuang/easy-lnmp/master/download.sh | bash`
 
此脚本会将安装脚本下载到当前用户的 Home 目录下的 `easy-lnmp` 目录并自动执行安装脚本，在安装
结束之后会在屏幕上输出 Mysql root 账号的密码，请妥善保存

在浏览器输入IP:80或者IP:8080就可以看到php7的具体信息 
## 查看安装过程的信息
* 进入目录`easy-lnmp/log`，执行 `tail -f info.log` 可以查看安装过程中的详细信息

## 启动命令和配置文件路径

#### redis
* 启动命令 `redis-cli`

#### Nginx
* 停止命令 `sudo service nginx stop`
* 启动命令 `sudo service nginx start` 
* 配置文件 `/etc/nginx/nginx.conf` 
* 配置路径 `/etc/nginx/conf.d` `/etc/nginx/sites-enabled`

两个站点路径
* 80端口 `/var/www/80` 
* 8080端口 `/var/www/8080`

#### php7
* 强制关闭 `sudo pkill php-fpm`
* 平滑重启 `sudo kill -USR2 $(cat /usr/local/php7.2.5/var/run/php-fpm.pid)`
* 安装路径 `/usr/local/php7.2.5`

php.ini位置 
* `/usr/local/php7.2.5/lib`

配置php-fpm的文件
* `/usr/local/php7.2.5/etc/php-fpm.conf`
* `/usr/local/php7.2.5/etc/php-fpm.d/www.conf`
#### MySQL
* 停止命令 `sudo service mysql stop`
* 启动命令 `sudo service mysql start`

配置文件路径
* `/etc/mysql/conf.d`
* `/etc/mysql/mysql.conf.d`

#### 安装成功
![success](https://raw.githubusercontent.com/Treehuang/easy-lnmp/master/success.png)
