#!/usr/bin/env bash

# author: i@shyi.io
# date: 2022/07/22
# update: 2022/07/22
# description: 一键配置各种镜像加速源

RED='\033[0;31m'
PLAIN='\033[0m'
check_root(){
	[[ $EUID -ne 0 ]] && echo -e "${RED}请使用 root 用户运行本脚本！${PLAIN}" && exit 1
}

check_system() {
    if grep -i 'debian' /etc/os-release | grep -i '10' > /dev/null 2>&1 ; then
        release="debian 10"
    elif grep -i 'debian' /etc/os-release | grep -i '11' > /dev/null 2>&1 ; then
        release="debian 11"
    elif grep -i 'ubuntu' /etc/os-release | grep -i '16.04' > /dev/null 2>&1 ; then
        release="ubuntu 16.04"
    elif grep -i 'ubuntu' /etc/os-release | grep -i '18.04' > /dev/null 2>&1 ; then
        release="ubuntu 18.04"
    elif grep -i 'ubuntu' /etc/os-release | grep -i '20' > /dev/null 2>&1 ; then
        release="ubuntu 20"
    elif grep -i 'centos' /etc/os-release | grep -i '7' > /dev/null 2>&1 ; then
        release="centos 7"
    elif grep -i 'centos' /etc/os-release | grep -i '8' > /dev/null 2>&1 ; then
        release="centos 8"
    fi
}

pre_info() {
    echo -e " 当前系统版本:" $release
    echo -e " 1. 更改yum/apt源 "
    echo -e " 2. 更改Docker源 "
    echo -e " 3. 更改pip源 "
    echo -e " 4. 退出 "
    while :; do echo
        read -p " 请输入数字选择模式：" selection_1
        if [[ ! $selection_1 =~ ^[1-4]$ ]]; then
            echo -ne "输入错误"
        else
            break
        fi
    done
}
inter_info_yum_or_apt() {
    echo -e " 1. 清华源 "
    echo -e " 2. 中科大源 "
    echo -e " 3. 阿里源 "
    echo -e " 4. 北交大源 "
    echo -e " 5. 恢复官方源 "
    while :; do echo
        read -p " 请输入数字选择模式：" selection_2
        if [[ ! $selection_2 =~ ^[1-4]$ ]]; then
            echo -ne "输入错误"
        else
            break
        fi
    done
}
inter_info_docker() {
    echo -e " 1. 中科大源 "
    echo -e " 2. 阿里源 "
    echo -e " 3. docker中国源 "
    echo -e " 4. daocloud源 "
    echo -e " 5. 网易源 "
    while :; do echo
        read -p " 请输入数字选择模式：" selection_3
        if [[ ! $selection_3 =~ ^[1-5]$ ]]; then
            echo -ne "输入错误"
        else
            break
        fi
    done
}
inter_info_pip() {
    echo -e " 1. 清华源 "
    echo -e " 2. 阿里源 "
    echo -e " 3. 豆瓣源 "
    echo -e " 4. 中科大源 "
    echo -e " 5. 华科源 "
    while :; do echo
        read -p " 请输入数字选择模式：" selection_4
        if [[ ! $selection_4 =~ ^[1-5]$ ]]; then
            echo -ne "输入错误"
        else
            break
        fi
    done
}

inter_change_yum_or_apt() {
    inter_info_yum_or_apt;
    if [ "${release}" == "centos 7" ]; then
        # yum -y update > /dev/null 2>&1
        yum -y install sudo > /dev/null 2>&1
        if [ ! -e '/root/yum.tar' ]; then
            sudo cd /root && sudo tar -cvf yum.tar /etc/yum.repos.d > /dev/null 2>&1
        fi

        if [[ ${selection_2} == 1 ]]; then
            sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' \
            -e 's|^#baseurl=http://mirror.centos.org|baseurl=https://mirrors.tuna.tsinghua.edu.cn|g' \
            -i.bak \
            /etc/yum.repos.d/CentOS-*.repo > /dev/null 2>&1
            sudo yum makecache > /dev/null 2>&1
        fi
        if [[ ${selection_2} == 2 ]]; then
            sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos|g' \
         -i.bak \
         /etc/yum.repos.d/CentOS-Base.repo > /dev/null 2>&1
            sudo yum makecache > /dev/null 2>&1
        fi
        if [[ ${selection_2} == 3 ]]; then
            sudo rm -rf /etc/yum.repos.d/* > /dev/null 2>&1
            curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo > /dev/null 2>&1
            sudo yum makecache > /dev/null 2>&1
        fi
        if [[ ${selection_2} == 4 ]]; then
            rm -rf /etc/yum.repos.d/* > /dev/null 2>&1
             > /etc/yum.repos.d/CentOS-Base.repo > /dev/null 2>&1
            sudo yum makecache > /dev/null 2>&1
        fi
    fi
    if [ "${release}" == "debian 10" ]; then
        apt -y update
        if [ ! -e '/etc/apt/sources.list.bak' ]; then
            sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
        fi
        if [[ ${selection_2} == 1 ]]; then
             > /etc/apt/sources.list > /dev/null 2>&1
            apt -y update > /dev/null 2>&1
        fi
        if [[ ${selection_2} == 2 ]]; then
             > /etc/apt/sources.list > /dev/null 2>&1
            apt -y update > /dev/null 2>&1
        fi
        if [[ ${selection_2} == 3 ]]; then
             > /etc/apt/sources.list > /dev/null 2>&1
            apt -y update > /dev/null 2>&1
        fi
        if [[ ${selection_2} == 4 ]]; then
             > /etc/apt/sources.list > /dev/null 2>&1
            apt -y update > /dev/null 2>&1
        fi
    fi
}

inter_change_docker() {
    inter_info_docker;
}
inter_change_pip() {
    inter_info_pip;
}

main() {
    check_root;
    check_system;
    pre_info;
    [[ ${selection_1} == 4 ]] && exit 1
    if [[ ${selection_1} == 1 ]]; then
        inter_change_yum_or_apt;
        echo -e " 修改完成 "
    elif [[ ${selection_1} == 2 ]]; then
        inter_change_docker;
    fi
    elif [[ ${selection_1} == 3 ]]; then
        inter_change_pip;
    fi
}
main