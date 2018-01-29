#!/usr/bin/env bash

local_dir=$(pwd)
logfile="/home/cy/log/sftp.log"

host=''
user=''
passwd=''
port=''

remote_dir="/root/test"

log(){
    echo "$(date + "%Y-%m-%d% %H:%M:%S")" "$1"
    echo "$(date "+%Y-%m-%d %H:%M:%S")" "$1" >> ${logfile}
}

# enter login info
login_info(){
    read -p "Enter your server IP addr: " ip
    [ -z "${ip}" ] && ip="Error,Please Enter remote host IP!"
    host=${ip}
    echo "server ip: $ip"
    read -p "Enter your username: " username
    [ -z "${username}" ] && username="Error,Please Enter username!"
    user=${username}
    echo "server username: $user"
    echo "------------------------------------------------"
}

# sftp connect
login(){
    sftp ${user}@${host} 2>&1 > /dev/null << EOF
exit
EOF
    [ $? -ne 0 ] && echo "SFTP Connect fail"
        echo "Connect Success"
        echo "------------------------------------------------"
}

# upload file
upload_file(){
    cd ${local_dir} || exit 
    login_info
    login
    local wait_file=("$@")
    sftp ${user}@${host} 2>&1 > /dev/null << EOF
lcd $local_dir
cd $remote_dir
mput ${wait_file[@]}
exit
EOF
    [ $? -eq 0 ] && echo "Upload file completed!"
}

# download file
download_file(){
    login_info
    login
    local wait_file={"$@"}
    sftp ${user}@${host} 2>&1 >/dev/null << EOF
cd $remote_dir
lcd $local_dir
mget ${wait_file[@]}
exit
EOF
    [ $? -eq 0 ] && echo "Download file completed!"
}

# select upload or download
# active
action=$1
[ -n "${1}" ] && upload_file $@
exit 1