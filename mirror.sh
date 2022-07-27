#!/usr/bin/env bash

# author: i@shyi.io
# date: 2022/07/22
# update: 2022/07/22
# description: 一键配置各种镜像加速源

check_system() {
    if grep -i 'debian' /etc/os-release | grep -i '10' > /dev/null 2>&1 ; then
        release="debian 10"
    elif grep -i 'debian' /etc/os-release | grep -i '11' > /dev/null 2>&1 ; then
        release="debian 11"
    elif grep -i 'ubuntu' /etc/os-release | grep -i '16' > /dev/null 2>&1 ; then
        release="ubuntu 16"
    elif grep -i 'ubuntu' /etc/os-release | grep -i '18' > /dev/null 2>&1 ; then
        release="ubuntu 18"
    elif grep -i 'ubuntu' /etc/os-release | grep -i '20' > /dev/null 2>&1 ; then
        release="ubuntu 20"
    elif grep -i 'centos' /etc/os-release | grep -i '7' > /dev/null 2>&1 ; then
        release="centos 7"
    elif grep -i 'centos' /etc/os-release | grep -i '8' > /dev/null 2>&1 ; then
        release="centos 8"
    fi
}
main() {
    check_system;
    echo $release
}
main