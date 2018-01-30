#!/usr/bin/env bash

[[ $EUID -ne 0 ]] && echo "Error: This script must be run as root!" && exit 1

# mysql login user
user="root"
passwd="password"
# backup date time dir
backup_date=$(date +%Y%m%d%H%M%S)
temp_dir="/home/backup/mysql/temp"
backup_dir="/home/backup/mysql"
log_file="${backup_dir}/backup.log"
dump_file="${temp_dir}/${backup_date}.sql"
tar_file="${backup_dir}/${backup_date}.tar.gz"
# database,dbname[0]="" → all databases
dbname[0]="mysql"
dbname[1]="jumpserver"
# dump sql foler
backup[0]=""

log(){
    echo "$(date +"%Y-%m-%d %H:%M:%S")" "$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S")" "$1" >> ${log_file}
}

mysql_backup() {
    if [ -z ${passwd} ]; then
        log "MySQL root password is empty"
    else
        log "MySQL dump start"
        mysql -u root -p"${passwd}" 2>/dev/null <<EOF
exit
EOF
        if [ $? -ne 0 ]; then
            log "MySQL root password is incorrect"
            exit 1
        fi

        if [ "${dbname[*]}" == "" ]; then
            mysqldump -u root -p"${passwd}" --all-databases > "${dump_file}" 2>/dev/null
            if [ $? -ne 0 ]; then
                log "MySQL all databases backup failed"
                exit 1
            fi
            log "MySQL all databases dump file name: ${dump_file}"
            backup=(${backup[*]} ${dump_file})
        else
            for db in ${dbname[*]}
            # for db in "${dbname[@]}"
            do
                single_db="${temp_dir}/${db}_${backup_date}.sql"
                mysqldump -u root -p"${passwd}" $db > "${single_db}" 2>/dev/null
                if [ $? -ne 0 ]; then
                    log "MySQL databases name [${db}] backup failed"
                    exit 1
                fi
                log "MySQL databases name [${db}] dump file name: ${single_db}"
                backup=(${backup[*]} ${single_db})
            done
        fi
        log "MySQL dump completed"
    fi
}

start_backup() {
    [ "${backup[*]}" == "" ] && echo "error"
    tar -zcPf ${tar_file} ${backup[*]}
    if [ $? -ne 0 ]; then
        log "Tar backup file failed"
        exit 1
    fi
    log "Tar backup file Success"

    # for sql in `ls ${temp_dir}/*.sql`
    # do
    #     log "Delete MySQL dump file: ${sql}"
    #     rm -rf ${sql}
    # done
}

start_time=$(date +%s)

if [ ! -d "${temp_dir}" ]; then
    mkdir -p ${temp_dir}
fi

log "Backup progress start"
mysql_backup
start_backup
log "Backup progress Success"

end_time=$(date +%s)
duration=$((end_time - start_time))
log "Backup commpleted in "${duration}" seconds"