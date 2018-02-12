#!/bin/bash

host=127.0.0.1

check(){
    cd /tmp
    file=$(hostname)
    head=$(date "+%Y/%m/%d %H:%M:%S")
    df -h|sed '1d'|sed 's/%//g'|awk '$5>70{print $0}' > $file
    if [ -s "${file}" ]; then
        echo -e "${file} ${head}\n" >> ${file}
        scp "${file}" "${host}":/home/cy/testlog > /dev/null 2>&1
        [ $? -eq 0 ] && echo "upload disk more than 70% file to $host SUCCESS"
    else
        echo "no disk space is less than 70%"
    fi
}

check