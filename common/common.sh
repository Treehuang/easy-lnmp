#!/bin/bash

COMMON_DIR=$( cd "$(dirname ${BASH_SOURCE})"; pwd -P )
source ${COMMON_DIR}/ansi

# 捕捉 ctrl+c 的信号, 写入fail状态
trap "echo fail > ${COMMON_DIR}/tmp.txt" SIGINT
ansi -n --green '[Deploy lnmp environment startup]'

# 消除光标
echo -e "\033[?25l"

# 日志文件
log=${COMMON_DIR}/../log/info.log

function call_function {
	func=$1
	info=$2
	
	# 检测是否有tmp.txt(记录每个函数最后的执行状态，succ, fail)，先消除干净
	if [[ -f ${COMMON_DIR}/tmp.txt ]]; then
		rm -rf ${COMMON_DIR}/tmp.txt
	fi
	
	# 函数运行在子进程中
	{
		${func} > ${log} 2>&1
		if [[ $? -eq 0 ]]; then
			echo 'succ' > ${COMMON_DIR}/tmp.txt
		else
			echo 'fail' > ${COMMON_DIR}/tmp.txt
		fi
	}&
	
	status=true
	# 主进程检测函数的运行状态(检测tmp.txt)
	while [[ ${status} = 'true' ]];
	do
		# 光标旋转效果(等同于loading)
		for j in '-' '\' '|' '/'
		do
			printf "\e[33m====> $info %s\r\e[0m" ${j}
			sleep 0.1
		done
		
		# 检测函数执行状态
		if [[ -f ${COMMON_DIR}/tmp.txt ]]; then
			tmp=$( cat ${COMMON_DIR}/tmp.txt )
			
			if [[ ${tmp} = 'succ' ]]; then
				status=false
				printf "\e[33m%-38s" "${info}"
				ansi --green "[DONE]  [OK]"
				rm -rf ${COMMON_DIR}/tmp.txt
			else
				status=false
				printf "\e[33m%-38s" "${info}"
				ansi --red "[DONE]  [FAIL]"
				echo -n -e "\033[?25h"        # 显示光标
				rm -rf ${COMMON_DIR}/tmp.txt
				exit
			fi
		fi
	done
}
