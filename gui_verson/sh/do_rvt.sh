#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin
export PATH

if [ "$1" == "mysqlBack.sql" ]; then
    mysql --defaults-file=./conf/localhost.cnf < ./.rvcache/mysqlBack.sql 
    if [ $? == '0' ]; then
        echo '...... done!'
    else
        echo 'Mysql data revert failed!'
    fi
else
    cd "./.rvcache"
    sudo -S tar -xjpP -f $1 > /dev/null 2>&1
    if [ $? == '0' ]; then
            echo "...... done! "        
        else
            echo "$1 revert failed"
    fi
fi
