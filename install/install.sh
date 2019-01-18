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
	ansi --inverse --bold --blue 'Please execute the script'
	echo -n -e "\033[?25h"; exit
fi


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

call_function init_system 'init the system'
call_function init_repositories 'init software source'
call_function install_basic_softwares 'install basic softwares'


echo -n -e "\033[?25h"
