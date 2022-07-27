#!/usr/bin/env bash

# author: i@shyi.io
# date: 2022/07/22
# update: 2022/07/22
# description: 一键配置各种镜像加速源

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
        yum -y update > /dev/null 2>&1
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
            curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
 > /dev/null 2>&1
            sudo yum makecache > /dev/null 2>&1
        fi
        if [[ ${selection_2} == 4 ]]; then
            echo "# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#

[base]
name=CentOS-$releasever - Base
baseurl=https://mirror.bjtu.edu.cn/centos/$releasever/os/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#released updates
[updates]
name=CentOS-$releasever - Updates
baseurl=https://mirror.bjtu.edu.cn/centos/$releasever/updates/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
baseurl=https://mirror.bjtu.edu.cn/centos/$releasever/extras/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
baseurl=https://mirror.bjtu.edu.cn/centos/$releasever/centosplus/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7" > /etc/yum.repos.d/CentOS-Base.repo > /dev/null 2>&1
            sudo yum makecache > /dev/null 2>&1
        fi
    fi
    if [ "${release}" == "debian 10" ]; then
        apt -y update
        if [ ! -e '/etc/apt/sources.list.bak' ]; then
            sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
        fi
        if [[ ${selection_2} == 1 ]]; then
            echo "# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free" > /etc/apt/sources.list > /dev/null 2>&1
            apt -y update > /dev/null 2>&1
        fi
        if [[ ${selection_2} == 2 ]]; then
            echo "deb https://mirrors.ustc.edu.cn/debian/ buster main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian/ buster main contrib non-free

deb https://mirrors.ustc.edu.cn/debian/ buster-updates main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian/ buster-updates main contrib non-free

deb https://mirrors.ustc.edu.cn/debian/ buster-backports main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian/ buster-backports main contrib non-free

deb https://mirrors.ustc.edu.cn/debian-security/ buster/updates main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian-security/ buster/updates main contrib non-free" > /etc/apt/sources.list > /dev/null 2>&1
            apt -y update > /dev/null 2>&1
        fi
        if [[ ${selection_2} == 3 ]]; then
            echo "deb http://mirrors.aliyun.com/debian/ buster main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib
deb http://mirrors.aliyun.com/debian-security buster/updates main
deb-src http://mirrors.aliyun.com/debian-security buster/updates main
deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" > /etc/apt/sources.list > /dev/null 2>&1
            apt -y update > /dev/null 2>&1
        fi
        if [[ ${selection_2} == 4 ]]; then
            echo "deb https://debian.bjtu.edu.cn/debian/ buster main non-free contrib
deb-src https://debian.bjtu.edu.cn/debian/ buster main non-free contrib
deb https://debian.bjtu.edu.cn/debian-security buster/updates main
deb-src https://debian.bjtu.edu.cn/debian-security buster/updates main
deb https://debian.bjtu.edu.cn/debian/ buster-updates main non-free contrib
deb-src https://debian.bjtu.edu.cn/debian/ buster-updates main non-free contrib
deb https://debian.bjtu.edu.cn/debian/ buster-backports main non-free contrib
deb-src https://debian.bjtu.edu.cn/debian/ buster-backports main non-free contrib" > /etc/apt/sources.list > /dev/null 2>&1
            apt -y update > /dev/null 2>&1
        fi
    fi
}


main() {
    check_root;
    check_system;
    echo "当前系统版本："
    echo $release
    inter_change_yum_or_apt;
}
main