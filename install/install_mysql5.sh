#!/bin/bash

VERSION=$( lsb_release -c -s )

DOWNLOAD_PATH=/root/download
MYSQL_PATH=${DOWNLOAD_PATH}/mysql5.7

length=${1:-23}
MYSQL_PASSWORD=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${length} | head -n 1`

if [[ ! -d ${DOWNLOAD_PATH} ]]; then
	mkdir ${DOWNLOAD_PATH}
fi

function install_mysql_start {
	sleep 2
}

function upgrade_package {
	apt-get upgrade
	apt-get -y install libaio1
}

function download_mysql {
	rm -rf ${MYSQL_PATH}
	mkdir ${MYSQL_PATH}

	cd ${MYSQL_PATH}

	if [[ ${VERSION} = 'trusty' ]]; then
		wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-server_5.7.24-1ubuntu14.04_amd64.deb-bundle.tar
		tar -xf mysql-server_5.7.24-1ubuntu14.04_amd64.deb-bundle.tar
	elif [[ ${VERSION} = 'xenial' ]]; then
		wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-server_5.7.24-1ubuntu16.04_amd64.deb-bundle.tar
		tar -xf mysql-server_5.7.24-1ubuntu16.04_amd64.deb-bundle.tar
	else
		return 1
	fi
}

function install_mysql {
	# 卸载mysql5.7
	debconf-set-selections <<< "mysql-community-server mysql-community-server/remove-data-dir seen true"
	apt -y purge mysql-*

	rm -rf /etc/mysql /var/lib/mysql

	if [[ -d ${MYSQL_PATH} ]]; then
		cd ${MYSQL_PATH}
	else
		return 1
	fi

	if [[ ${VERSION} = 'trusty' ]]; then
		
		dpkg -i mysql-common_5.7.24-1ubuntu14.04_amd64.deb
		debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password ${MYSQL_PASSWORD}"
		debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password ${MYSQL_PASSWORD}"
		dpkg-preconfigure mysql-community-server_5.7.24-1ubuntu14.04_amd64.deb
		dpkg -i libmysqlclient20_5.7.24-1ubuntu14.04_amd64.deb
		dpkg -i libmysqlclient-dev_5.7.24-1ubuntu14.04_amd64.deb
		dpkg -i libmysqld-dev_5.7.24-1ubuntu14.04_amd64.deb
		dpkg -i mysql-community-client_5.7.24-1ubuntu14.04_amd64.deb
		dpkg -i mysql-client_5.7.24-1ubuntu14.04_amd64.deb
		dpkg -i mysql-community-source_5.7.24-1ubuntu14.04_amd64.deb
		apt-get -f install
		apt-get -f install libmecab2
		dpkg -i mysql-community-server_5.7.24-1ubuntu14.04_amd64.deb
		dpkg -i mysql-server_5.7.24-1ubuntu14.04_amd64.deb

	elif [[ ${VERSION} = 'xenial' ]]; then
	
		dpkg -i mysql-common_5.7.24-1ubuntu16.04_amd64.deb
		debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password ${MYSQL_PASSWORD}"
		debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password ${MYSQL_PASSWORD}"
		dpkg-preconfigure mysql-community-server_5.7.24-1ubuntu16.04_amd64.deb
		dpkg -i libmysqlclient20_5.7.24-1ubuntu16.04_amd64.deb
		dpkg -i libmysqlclient-dev_5.7.24-1ubuntu16.04_amd64.deb
		dpkg -i libmysqld-dev_5.7.24-1ubuntu16.04_amd64.deb
		dpkg -i mysql-community-client_5.7.24-1ubuntu16.04_amd64.deb
		dpkg -i mysql-client_5.7.24-1ubuntu16.04_amd64.deb
		dpkg -i mysql-community-source_5.7.24-1ubuntu16.04_amd64.deb
		apt-get -f install
		apt-get -f install libmecab2
		dpkg -i mysql-community-server_5.7.24-1ubuntu16.04_amd64.deb
		dpkg -i mysql-server_5.7.24-1ubuntu16.04_amd64.deb

	else
		return 1
	fi
}

function start_mysql {
	service mysql restart
}
