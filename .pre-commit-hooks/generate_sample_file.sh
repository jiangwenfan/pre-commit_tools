#!/bin/bash
# 执行出错时，退出
set -e

# check use. 参数个数小于2，提示使用方法
if [ $# -lt 2 ];then
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
config_file_name_sample_target="${config_file_name}.sample"
config_file_name_sample="${config_file_name}.temp"
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
	# 使用 uname 命令获取系统类型
	os_type=$(uname)

	# 判断系统类型并输出
	if [ "$os_type" == "Darwin" ]; then
		sed -i "" "s#${line}#${key_value_new}#g" "${config_file_name_sample}"
	elif [ "$os_type" == "Linux" ]; then
		sed -i "s#${line}#${key_value_new}#g" "${config_file_name_sample}"
	elif [ "$os_type" == "FreeBSD" ]; then
		echo "This is FreeBSD."
		exit 1
	else
		echo "Unknown operating system."
		exit 1
	fi

done
echo "${config_file_name_sample} handle ok!"
# check file exist
if [ ! -f "${config_file_name_sample_target}" ];then
	mv ${config_file_name_sample} ${config_file_name_sample_target}
else
	# 计算文件的 MD5 校验和
	md5_1=$(md5sum "${config_file_name_sample_target}" | awk '{print $1}')
	md5_2=$(md5sum "${config_file_name_sample}" | awk '{print $1}')

	# 判断 MD5 校验和是否相同.
	# TODO 根据系统，mac系统使用md5,linux系统使用md5sum
	# TODO 生成env文件和 toml文件拆分为2个hook
	if [ "$md5_1" = "$md5_2" ]; then
		echo "MD5 checksums match. The files are identical."
		rm -rf ${config_file_name_sample}
	else
		echo "MD5 checksums do not match. The files are different."
		mv ${config_file_name_sample} ${config_file_name_sample_target}
	fi
fi
