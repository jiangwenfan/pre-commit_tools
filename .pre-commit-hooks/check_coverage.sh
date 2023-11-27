#!/bin/bash
# 绿色表示关键信息
# 蓝色表示每个阶段
# 红色表示错误信息

echo -e "\e[34mRunning tests and checking coverage...\e[0m"

# check arguments
if [ "$#" -lt 3 ]; then
    echo -e "\e[31m参数数量小于3,退出! arg1: container_name, arg2: manage_file, arg3: coverage_threshold\e[0m"
    exit 1
else
    container_name="$1"
    manage_file="$2"
    coverage_threshold=$3  # set your desired coverage threshold here
    echo -e "\e[32mcontainer_name: ${container_name}\nmanage_file: ${manage_file}\ncoverage_threshold: ${coverage_threshold}\e[0m \n"
fi


echo -e "\e[34m[1]running tests...\e[0m"
docker exec ${container_name} coverage run ${manage_file} test --noinput

if [ "$?" -ne 0 ]; then
    echo -e "\e[31mTests failed. Commit aborted.\e[0m"
    exit 1
fi
echo -e "\n"


echo -e "\e[34m[2]running coverage report...\e[0m\n"
coverage_res=$(docker exec ${container_name} coverage report | grep TOTAL | awk '{print $4}'| tr -d '%')

if [ "$?" -ne 0 ]; then
    echo -e "\e[31mcoverage report failed. Commit aborted.\e[0m"
    exit 1
fi



echo -e "\e[34m[3]Checking coverage...\e[0m"
# echo -e "threshold: ${coverage_threshold}%  actual: ${coverage_res}%\n"
# ls -l abdblsda
# exit 1

if [ ${coverage_res} -lt ${coverage_threshold} ]; then
    echo -e "\e[31mCoverage is below threshold. Commit aborted.\e[0m"
    echo -e "\e[32mthreshold: ${coverage_threshold}%  actual: ${coverage_res}%\e[0m \n"
    exit 1
fi

if [ "$?" -ne 0 ]; then
    echo -e "\e[31mCoverage check failed. Commit aborted.\e[0m"
    exit 1
fi


echo "Tests and coverage passed. Commit allowed."