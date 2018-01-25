#!/bin/bash

# get current folder
curr_dir=$(pwd)

# check system
check_sys() {
    local checkType=$1
    local value=$2

    local release=''
    local cmd=''

    if [ -f /etc/redhat-release ]; then
        release="centos"
        cmd="yum"
    elif [ -f /etc/debian_version ]; then
        release="debian_distribute"
        cmd="apt"
    elif cat /etc/issue | grep -i "ubuntu"; then
        release="ubuntu"
        cmd="apt"
    elif cat /etc/issue | grep -i "debian"; then
        release="debian"
        cmd="apt"
    elif cat /etc/issue | grep -Ei "centos|red hat|redhat"; then
        release="centos"
        cmd="yum"
    elif cat /proc/version | grep -i "debian"; then
        release="debian"
        cmd="apt"
    elif cat /proc/version | grep -i "ubuntu"; then
        release="ubuntu"
        cmd="apt"
    elif cat /proc/version | grep -i "centos|red hat|redhat"; then
        release="centos"
        cmd="yum"
    fi
    if [[ ${checkType} == "sysRelease" ]]; then
        if [ "$value" == "$release" ]; then
            return 0
        else
            return 1
        fi
    elif [[ ${checkType} == "packageManager" ]]; then
        if [ "$value" == "$cmd" ]; then
            return 0
        else
            return 1
        fi
    fi
}

# nginx dependcies
if check_sys packageManager yum; then
    yum install -y curl wget gcc gcc-c++ autoconf automake make zlib zlib-devel libtool openssl openssl-devel pcre pcre-devel perl
elif check_sys packageManager apt; then
    apt update
    apt install -y curl wget make gcc libpcre3 libpcre3-dev zlib1g zlib1g-dev libtool openssl libssl-dev perl
fi
cd ${curr_dir}

# ngx_lua dependcies
# get_file(){
#     if ! wget --no-check-certificate http://luajit.org/download/LuaJIT-2.0.5.tar.gz; then
#         echo "Failed to download LuaJIT file!"
#         exit 1
#     elif ! wget --no-check-certificate https://github.com/simpl/ngx_devel_kit/archive/v0.3.1rc1.tar.gz; then
#         echo "Failed to download ngx_devel_kit file!"
#         exit 1
#     elif ! wget --no-check-certificate https://github.com/openresty/lua-nginx-module/archive/v0.10.12rc2.tar.gz; then
#         echo "Failed to download ngx_lua file!"
#         exit 1
#     fi
# }

# download nginx
download_file() {
    if [ -f openresty.tar.gz ]; then
        return 0
    elif ! wget --no-check-certificate -O openresty.tar.gz https://openresty.org/download/openresty-1.13.6.1.tar.gz; then
        echo "Failed to download openresty.tar.gz file!"
        exit 1
    fi
}

# unzip package
tar_archive() {
    cd ${curr_dir}
    tar zxf openresty.tar.gz
    if [ $? -ne 0 ]; then
        echo "Unzip failed, please check the command or package"
        install_cleanup
        exit 1
    fi
}

# ngx configure make
configure_nginx() {
    cd openresty-1.13.6.1
    if [ $? -ne 0 ]; then
        echo "not found openresty dir"
        exit 1
    else
        echo "------------------configure---------------------"
        ./configure --prefix=/usr/local/openresty
        echo "--------------make && make install--------------"
        make && make install
        echo "---------------------end------------------------"
    fi
}

# openresty_dir
openresty_dir=/usr/local/openresty
systemd=/lib/systemd/system
# join system service
service() {
    ${openresty_dir}/nginx/sbin/nginx -t
    if [ $? -ne 0 ]; then
        echo "nginx install error,please check conf or process"
        exit 1
    else
        wget --no-check-certificate -P ${systemd} https://raw.githubusercontent.com/cyoncan/Shell/master/openresty.service
    fi
}

# install cleanup
install_cleanup() {
    cd ${curr_dir}
    rm -rf *
}

# install
install() {
    download_file
    tar_archive
    configure_nginx
}

# uninstall
# uninstall() {
#     install_cleanup
#     cd ${openresty_dir}
#     rm -rf *
#     cd ${systemd}
# }

# active install
action=$1
[ -z $1 ] && install
