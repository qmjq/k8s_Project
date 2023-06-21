#!/bin/bash
# description:	Automatically add NODE through web front-end parameters,But you can also manually execute it
# author:	jingge i
# 2020401 v1

set -e
#set -x
DATE=$(date +%Y%m%d-%H%M%S)
base_dir="/usr/local/src/ansible"
bin_dir="/opt/kube/bin"


function syntax(){
    	[ ! -z "$1" ] && echo ">>[$(date "+%Y%m%d.%H%M%S")] $1"
    	echo " "
    	echo " syntax:"
    	echo " bash ${shell_name} -hostName jingge -ipaddr 192.168.1.168 -hostblock sz-az1-b1 -hostzone sz-az1 -hostcenter sz -disktype [nvme|ssd|hdd] -rescategory [high|header|balance]  "
    	echo "	
		1、ip_addr变量为需要添加节点IP
        	2、host_name变量为主机名
        	3、host_block 为主机所属区域块, 如sz-cs-b1
        	4、host_zone为主机所属zone , 如 sz-cs
        	5、host_center为主机所属center，如 sz 
        	6、disk_type为主机硬盘类型,        如 nvme、ssd、 hdd 
        	7、rescategory为机所属分类,        如 high、header、balance
	"
    	echo " Sample: bash ${shell_name} -hostName jingge -ipaddr 192.168.1.168 -hostblock sz-az1-b1 -hostzone sz-az1 -hostcenter sz -disktype hdd -rescategory balance"
    	echo " "
    	echo " Author: lijing"
   	exit 22
}

function input_parameter (){
#put  all the input-options in corresponding variables:
	for inopt in ${ShellOption}
	do
  	 case $(echo $inopt|tr a-z A-Z) in
  		-ipaddr|-IPADDR) CurOpt="-IPADDR";continue;;
  		-hostname|-HOSTNAME) CurOpt="-HOSTNAME";continue;;
  		-hostblock|-HOSTBLOCK) CurOpt="-HOSTBLOCK";continue;;
  		-hostzone|-HOSTZONE) CurOpt="-HOSTZONE";continue;;
  		-hostcenter|-HOSTCENTER) CurOpt="-HOSTCENTER";continue;;
  		-disktype|-DISKTYPE) CurOpt="-DISKTYPE";continue;;
  		-rescategory|-RESCATEGORY) CurOpt="-RESCATEGORY";continue;;
  		-HELP|-H) CurOpt="HELP";syntax;;
		-*) CurOpt="";f_PrintLog "Warn" "Exception option [${inopt}]";syntax;;
  	 esac
  	 case "${CurOpt}" in
  		-IPADDR) typeset -g ip_addr="${inopt}";continue;;
  		-HOSTNAME) typeset -g host_name="${inopt}";continue;;
  		-HOSTBLOCK) typeset -g host_block="${inopt}";continue;;
  		-HOSTZONE) typeset -g host_zone="${inopt}";continue;;
  		-HOSTCENTER) typeset -g host_center="${inopt}";continue;;
  		-DISKTYPE) typeset -g disk_type="${inopt}";continue;;
  		-RESCATEGORY) typeset -g rescategory="${inopt}";continue;;
  		-*) CurOpt="";f_PrintLog "Warn" "Exception option [${inopt}]";syntax;;
  	 esac
	done
	#check para value
	[ -z "${ip_addr}" ] && f_PrintLog  "Error" "ipaddr must not null." && exit 22;
	[ -z "${host_name}" ] && f_PrintLog  "Error" "hostname must not null." && exit 22;
	[ -z "${host_block}" ] && f_PrintLog  "Error" "hostblock must not null." && exit 22;
	[ -z "${host_zone}" ] && f_PrintLog  "Error" "hostzone must not null." && exit 22;
	[ -z "${host_center}" ] && f_PrintLog  "Error" "hostcenter must not null." && exit 22;
	[ -z "${disk_type}" ] && f_PrintLog  "Error" "disktype must not null." && exit 22;
	[ -z "${rescategory}" ] && f_PrintLog  "Error" "rescategory must not null." && exit 22;

	disk_type=$(echo "${disk_type}"|tr A-Z a-z |egrep "hdd|ssd|nvme")
	if [ -z "${disk_type}" ] ;then
        	f_PrintLog  "Error" "The disk type:${disk_type} is not support,must be [hdd|ssd|nvme]!"  &&  exit 22;
	fi
	rescategory=$(echo "${rescategory}"|tr A-Z a-z |egrep "high|header|balance")
	if [ -z "${rescategory}" ] ;then
        	f_PrintLog  "Error" "The disk type:${rescategory} is not support,must be [high|header|balance]!"  &&  exit 22;
	fi
	f_clear_logfile
}

function f_PrintLog(){
    	if [ $# -lt 2 ]; then
        	echo "Error,please useage log_level message [logfile]"
        	return 0
    	fi
    	log_level=$(echo "$1"|tr  "a-z" "A-Z")
    	log_level_info=$(echo "${log_level}" |egrep -w "WARN|INFO|ERROR")
    	if [ -z "${log_level_info}" ] ;then
        	echo "[`date +'%F %T'`]|${UserName}@${HostName}|ERROR|The log_level:${log_level} is error,please input [WARN|INFO|ERROR]";exit 22;
    	fi
    	message=$2
    	#logfile=${3:-$LogFile}
    	logfile="${LogFile}"
    	echo  -e "[`date +'%F %T'`]|${UserName}@${HostName}|${log_level}|${message}"| tee -a  ${logfile}
}

function f_clear_logfile(){
    	#if log size greate than 5M ,clean it
    	if [ -f "${LogFile}" ] ;then
        	log_size_info=$(du -b ${LogFile}|awk '{print $1}')
        	log_size=$(awk 'BEGIN{printf "%.f\n", '${log_size_info}'/1024/1024}')
        	#echo "${log_size}"
        	if [ ${log_size} -ge 5 ] ;then
            		echo -n "">"${LogFile}"
            		echo "log size is greate than ${log_size}M,clear ${LogFile} success."
        	fi
    	fi
}

function add_node_check (){
	ansible-playbook -i $base_dir/example/hosts_$DATE $base_dir/add-node-check.yml  2>&1 |tee -a $LogFile
}

function add_node_prepare (){
	ansible-playbook -i $base_dir/example/hosts_$DATE $base_dir/add-node-prepare.yml 2>&1 |tee -a $LogFile
}

function add_node () {
	ansible-playbook -i $base_dir/example/hosts_$DATE $base_dir/add-node.yml 2>&1 |tee -a $LogFile
}

function main (){
	WorkDir=$(
    	cd $(dirname $0)
   	pwd
 	)
	shell_name="$(echo $0|awk -F / '{print $NF}')";ShellOption="$@";ShellPID=$$
	LogDir="${WorkDir}/logs";mkdir -p ${LogDir};chmod -R 777 ${LogDir} 2>/dev/null
	LogFile="${LogDir}/${shell_name}.log"
	UserName=$(whoami);LogLevel=3;HostName=$(uname -n);uname_a=$(uname -a);Platform=$(echo ${uname_a%% *}|tr a-z A-Z);

	#put  all the input-options in corresponding variables:
	input_parameter 

	#cd $base_dir
	node_lines=$(echo $ip_addr  NODE_HOSTNAME=$host_name HOST_BLOCK=$host_block HOST_ZONE=$host_zone HOST_CENTER=$host_center DISK_TYPE=$disk_type RESCATEGORY="$rescategory") && echo $node_lines
	cp $base_dir/example/hosts $base_dir/example/hosts_$DATE -a 
	sed -i '/add\-node/a'\ "$node_lines" $base_dir/example/hosts_$DATE
	add_node_check 
	add_node_prepare
	add_node
	mv -f $base_dir/example/hosts_$DATE /tmp/

	#成功标记，不允许修改，放到脚本最后输出
	f_PrintLog "INFO" "code=0 and msg=success"
}


main ${@} 
