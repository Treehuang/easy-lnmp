#!/bin/bash

LONG_BIT=$(uname -m)

VERSION_ARRAY=('trusty', 'xenial')

VERSION=$(lsb_release -c -s)

echo ${VERSION[@]} | grep -wq "${VERSION}" && DISTRO='Yes' || DISTRO='No'

lsb_release -d | grep 'Ubuntu' >& /dev/null
if [[ $? -ne 0 || ${DISTRO} != 'Yes' || ${LONG_BIT} != 'x86_64' ]]; then
    echo -e "\e[1;31mOnly Ubuntu 14.04LTS/16.04LTS(x86_64) is supported!\e[0m"
    exit
fi

if [[ $(id -u) -ne 0 ]]; then
    echo -e "\e[1;31mPlease execute the script with root!\e[0m"
    exit
fi

cd $HOME
echo -e "\033[32m====> Download...\e[0m"
sleep 1

wget -q https://github.com/Treehuang/easy-lnmp/archive/master.tar.gz -O easy-lnmp.tar.gz
rm -f easy-lnmp
tar -xf easy-lnmp.tar.gz > /dec/null 2>&1
mv easy-lnmp-master easy-lnmp
rm -rf easy-lnmp.tar.gz

echo -e "\e[3;34mThe script path: ${HOME}/easy-lnmp\e[0m"
echo -e "\e[3;34m=================================\e[0m"

cd ${HOME}/easy-lnmp/install

./install.sh
