#!/bin/bash

INSTALL_DIR=$( cd "$(dirname ${BASH_SOURCE})"; pwd -P )
source ${INSTALL_DIR}/../common/common.sh

LONG_BIT=$( uname -m )

# ubuntu 版本, trusty为14.04LTS, xenial为16.04LTS
VERSION_ARRAY=('trusty', 'xenial')

# 检测 ubuntu 版本
VERSION=$( lsb_release -c -s )

# 如果 Ubuntu 版本都不是指定的版本，将DISTRO设置为No
echo ${VERSION_ARRAY[@]} | grep -wq ${VERSION} && DISTRO='Yes' || DISTRO='No'

lsb_release -d | grep 'Ubuntu' >& /dev/null
if [[ $? -ne 0 ||  ${DISTRO} != 'Yes' || ${LONG_BIT} != 'x86_64' ]]; then
	ansi --inverse --bold --blue 'Only ubuntu 14.04LTS/16.04LTS(x86_64) is supported!'
	echo -n -e "\033[?25h"; exit
fi


# 检测是否为 root 用户
if [[ $( id -u ) -ne 0 ]]; then
	ansi --inverse --bold --blue 'please execute the script with root'
	echo -n -e "\033[?25h"; exit
fi

# 包含install文件夹的所有脚本，除开 install.sh
for script_file in `ls -I 'install.sh' ./`
do
	source ${INSTALL_DIR}/${script_file}
done

# 初始化系统，设置编码和时间
function init_system {
	export LC_ALL='en_US.UTF-8'

	cat /etc/default/locale | grep LC_ALL=en_US.UTF-8 >& /dev/null
	if [[ $? -ne 0 ]]; then
		echo LC_ALL='en_US.UTF-8' >> /etc/default/locale
	fi
	
	locale-gen en_US.UTF-8
	locale-gen zh_CN.UTF-8

	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	sleep 1
}

# 初始化仓库
function init_repositories {
	rm /var/cache/apt/archives/lock
	rm /var/lib/dpkg/lock

	add-apt-repository -y ppa:nginx/stable
	grep -rl ppa.launchpad.net /etc/apt/sources.list.d/ | xargs sed -i 's/ppa.launchpad.net/launchpad.proxy.ustclug.org/g'
	
	apt-get update
}

function install_basic_softwares {
	apt-get install -y vim curl make git unzip supervisor
}

function install_redis {
	apt-get install -y redis-server
	service redis-server restart
}

function install_composer {
	wget https://dl.laravel-china.org/composer.phar -qO /bin/composer
	chmod +x /bin/composer
}

#call_function init_system 'init the system'
#call_function init_repositories 'init software source'
#call_function install_basic_softwares 'install basic softwares'
#call_function install_redis 'install redis'
#call_function install_php '[install php7 startup]'
#call_function install_dependenices 'install dependecices'
#call_function download_php 'download php7'
#call_function configure_php 'configure php7'
#call_function make_install_php 'install php7, about 25 min'
#call_function start_up 'start php7'
call_function install_nginx 'install nginx'
call_function install_composer 'install composer'

echo -n -e "\033[?25h"
