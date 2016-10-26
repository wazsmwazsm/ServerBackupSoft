#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin
export PATH

if [ "$1" == "mysqldata" ]; then
    mysqldump --defaults-file=./conf/localhost.cnf --all-databases > ./.pkcache/mysqlBack.sql 
    if [ $? == '0' ]; then
        echo '...... done!'
    else
        echo 'Mysql data package failed!'
        # 防止生成无效的mysql文件
        rm ./.pkcache/mysqlBack.sql
    fi
else
    cd "./.pkcache"
    echo 'wzdanzsm' | sudo -S tar cjP -f "${1////_}.tar.bz2"  $1 > /dev/null 2>&1
    if [ $? == '0' ]; then
            echo "...... done! "        
        else
            echo "$1 package failed"
    fi
fi