#!/bin/bash
# 执行出错时，退出
set -e

# check use
if [ $# -ne 2 ];then
	echo "Usage: $0 <filename> <file_type>"
    	exit 1
fi

# check file type
config_file_type="$2"
if [ "${config_file_type}" != "toml" ] && [ "${config_file_type}" != "env" ];then
	echo "only support config file type: toml,env"
	exit 1
fi

# generate sample file
config_file_name="$1"
config_file_name_sample="${config_file_name}.sample"
cp ${config_file_name} ${config_file_name_sample}

# read file
all_key_value=`cat ${config_file_name_sample} |grep -v "#"|grep "="`

# IFS= 设置了输入字段分隔符为空，这样read命令在读取每一行时不会删除行首行尾的空格或制表符。
# -r 防止read对反斜杠进行转义
# read 将按行读取的变量存储到line中
echo  "${all_key_value}" | while IFS= read -r line; do
	key=$(echo "$line" | awk -F'=' '{print $1}')
	value=$(echo "$line" | awk -F'=' '{print $2}')
	# 去除字符串2边空格
	value_clean=`echo ${value}`
	if [[ "${value_clean}" =~ ^\".*\"$ ]];then
		# value被双引号包裹
		if [ "${config_file_type}" == "toml" ];then
			key_value_new="$key = \"\""
		elif [ "${config_file_type}" == "env" ];then
			key_value_new="$key=\"\""
		else
			echo "not support"
			exit 1
		fi
	else
		# value没有被双引号包裹
		if [ "${config_file_type}" == "toml" ];then
			key_value_new="$key = "
		elif [ "${config_file_type}" == "env" ];then
			key_value_new="$key="
		else
			echo "not support"
			exit 1
		fi

	fi
	# 替换
	#if echo "$line" | grep -q '#'; then
    	#	echo "字符串中包含#字符" $line
	#fi
	sed -i "s#${line}#${key_value_new}#g" ${config_file_name_sample}
done
echo "${config_file_name_sample} handle ok!"