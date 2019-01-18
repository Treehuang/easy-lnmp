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

if [[ $( id -u ) -ne 0 ]]; then
	ansi --inverse --bold --blue 'Please execute the script'
	echo -n -e "\033[?25h"; exit
fi





echo -n -e "\033[?25h"
