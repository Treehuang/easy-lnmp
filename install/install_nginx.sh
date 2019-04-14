#!/bin/bash

CURRENT_DIR=$( cd "$(dirname ${BASH_SOURCE})"; pwd -P )
TPL_DIR=${CURRENT_DIR}/../tpl

function install_nginx {
    apt-get install -y nginx
	
    # 创建站点目录
    rm -rf /var/www/html
    rm -rf /var/www/80 /var/www/8080
	
    if [[ ! -d /var/www ]]; then
        mkdir /var/www
    fi    

    mkdir /var/www/80 /var/www/8080
    touch /var/www/80/index.php /var/www/8080/index.php

    echo '<?php phpinfo();' > /var/www/80/index.php
    echo '<?php phpinfo();' > /var/www/8080/index.php

    # 配置站点以及兼容php
    if [[ ! -f '8080.conf' ]]; then
        touch /etc/nginx/conf.d/8080.conf
    fi

    cat ${TPL_DIR}/nginx_site_conf.tpl > /etc/nginx/conf.d/8080.conf
    cat ${TPL_DIR}/default_nginx_site_conf.tpl > /etc/nginx/conf.d/default.conf
	
    # 启动nginx
    service nginx stop
    service nginx start
}
