#!/bin/bash

mail=$1
user=$3
root=/root/.ssh
tracker=/home/tracker/.ssh
loguser=/home/loguser/.ssh

for_key() {
    cd $loguser
    num_loguser=$(grep -n $mail authorized_keys | awk -F: 'NR==1{print $1}')
    if [ -n "$num_loguser" ]; then
        ln_key=$(expr $num_loguser + 1)
        loguser_key=$(awk 'NR==var{print $0}' var=$tn_key authorized_keys)
        if [ -n "$loguser_key" ]; then
            get_path=$loguser
        fi
    fi

    cd $tracker
    num_tracker=$(grep -n $mail authorized_keys | awk -F: 'NR==1{print $1}')
    if [ -n "$num_tracker" ]; then
        tn_key=$(expr $num_tracker + 1)
        tracker_key=$(awk 'NR==var{print $0}' var=$tn_key authorized_keys)
        if [ -n "$tracker_key" ]; then
            get_path=$tracker
        fi
    fi

    cd $root
    num_root=$(grep -n $mail authorized_keys | awk -F: 'NR==1{print $1}')
    if [ -n "$num_root" ]; then
        rn_key=$(expr $num_root + 1)
        root_key=$(awk 'NR==var{print $0}' var=$rn_key authorized_keys)
        if [ -n "$root_key" ]; then
            get_path=$root
        fi
    fi

    case $user in
    loguser)
        del_path=$loguser
        ;;
    tracker)
        del_path=$tracker
        ;;
    root)
        del_path=$root
        ;;
    *)
        echo "$1 key is not under any user"
        ;;
    esac
}

# which_key() {
#     arry_key=($loguser_key $tracker_key $root_key)
#     arry_path=($loguser $tracker $root)
#     init_cnt=0
#     for i in ${arry_key[@]};do
#         if [ -n $i ]; then
#             j=$i
#             for j in ${arry_key[@]};do
#                 if test "$j" = "$i"; then
#                     echo $init_cnt
#                     return
#                 fi
#             init_cnt=$(($init_cnt+1))
#             g_path=${arry_path[$init_cnt]}
#             done
#         fi
#     done
# }

get_key() {
    cd $get_path
    num_mail=$(grep -n $mail authorized_keys | awk -F: 'NR==1{print $1}')
    if [ -n "$num_mail" ]; then
        num_key=$(expr $num_mail + 1)
        key=$(awk 'NR==var{print $0}' var=$num_key authorized_keys)
        echo $key
        echo "Get KEY SUCCESS"
    else
        echo "Email Invild"
    fi
}

add_key() {
    case $user in
    loguser)
        key_path=$loguser
        ;;
    tracker)
        key_path=$tracker
        ;;
    root)
        key_path=$root
        ;;
    *)
        echo "Arguments Error,Please check user name"
        ;;
    esac

    cd $key_path
    local if_key=$(grep "$key" authorized_keys)
    if [ -z "$if_key" ]; then
        echo "# $mail" >>authorized_keys
        echo "$key" >>authorized_keys
        echo "Add Key SUCCESS"
    else
        echo "The Key Is Exsit"
    fi
}

del_key() {
    cd $del_path
    local if_key=$(grep "$key" authorized_keys)
    if [ -z "$if_key" ]; then
        echo "Key is does't exsit, Please check"
    else
        n=$(grep -n $mail authorized_keys | awk -F: 'NR==1{print $1}')
        m=$(expr $n + 1)
        if [ $m = 1 ]; then
            sed -i "$m"d authorized_keys
        else
            sed -i "$n,$m"d authorized_keys
            echo "Delete key complete"
        fi
    fi
}

for_key
get_key

action=$2
[ -z $2 ] && action=add
case $action in
add | del)
    ${action}_key
    ;;
*)
    echo "Arguments error!"
    echo "Usage: $(basename $0) [add|del]"
    ;;
esac

# while [ $# -gt 0 ];do
#     case $1 in
#     -u|--user)
#         shift
