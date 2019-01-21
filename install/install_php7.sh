#!/bin/bash

# tpl 文件夹路径
CURRENT_DIR=$( cd "$( dirname ${BASH_SOURCE} )"; pwd -P )
TPL_DIR=${CURRENT_DIR}/../tpl

DOWNLOAD_PATH=/root/download

if [[ ! -d ${DOWNLOAD_PATH} ]]; then
	mkdir ${DOWNLOAD_PATH}
fi

function install_php {
	rm -rf /usr/local/php7.2.5
	mkdir /usr/local/php7.2.5
}

function install_dependenices {
	apt-get -y install build-essential
	apt-get -y install libxml2-dev
	apt-get -y install libssl-dev
	apt-get -y install libcurl4-gnutls-dev
	apt-get -y install libgd-dev
}

function download_php {
	# 进入下载的路径
	cd ${DOWNLOAD_PATH}

	# 删除因中断(网络)产生错误而残留下来的文件
	rm -rf php-7.2.5 php-7.2.5.tar.gz

	# 下载和解压
	wget http://am1.php.net/distributions/php-7.2.5.tar.gz
    tar -xzf php-7.2.5.tar.gz

	# 删除压缩包
	rm -rf php-7.2.5.tar.gz
}

function configure_php {
	# 进入解压后的路径
	if [[ -d ${DOWNLOAD_PATH}/php-7.2.5 ]]; then
		cd ${DOWNLOAD_PATH}/php-7.2.5
	else
		return 1
	fi

	./configure --prefix=/usr/local/php7.2.5 --enable-opcache --enable-fpm --enable-maintainer-zts --with-gd --with-zlib --with-jpeg-dir=/usr --with-png-dir=/usr --with-pdo-mysql=mysqlnd --with-mysqli --enable-mbstring --enable-sockets --with-curl --with-openssl --enable-pcntl --with-fpm-user=www-data --with-fpm-group=www-data
	
	
}

function make_install_php {
	# 进入解压后的路径
    if [[ -d ${DOWNLOAD_PATH}/php-7.2.5 ]]; then
        cd ${DOWNLOAD_PATH}/php-7.2.5
    else
        return 1
    fi

	make && make install

	cp /usr/local/php7.2.5/bin/php /bin
    cp /usr/local/php7.2.5/bin/phpize /bin
    cp /usr/local/php7.2.5/sbin/php-fpm /bin
    cp /usr/local/php7.2.5/etc/php-fpm.conf.default /usr/local/php7.2.5/etc/php-fpm.conf
    cp /usr/local/php7.2.5/etc/php-fpm.d/www.conf.default /usr/local/php7.2.5/etc/php-fpm.d/www.conf
	
	# 创建存放php7.2-fpm.sock的文件路径
    mkdir /var/run/php

	# 配置php-fpm.conf, www.conf文件
    cat "${TPL_DIR}/php_fpm_conf.tpl" > /usr/local/php7.2.5/etc/php-fpm.conf
    cat "${TPL_DIR}/www_conf.tpl" > /usr/local/php7.2.5/etc/php-fpm.d/www.conf
	
	# 下载配置文件
    phpini_path=/usr/local/php7.2.5/lib
    cd ${phpini_path}
    wget -O php.ini https://raw.githubusercontent.com/php/php-src/master/php.ini-development
}

function start_up {
	sleep 1

	pkill php-fpm
	php-fpm

	# 赋予php7.2-fpm.sock读写权限
	chmod 666 /var/run/php7.2-fpm.sock
}

