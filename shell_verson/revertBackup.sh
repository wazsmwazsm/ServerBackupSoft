#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin
export PATH

function rvt() {
    read -p "Do you want to revert $1 now ? [Y/N] : " yn
    while [ "$yn" != "Y" ] && [ "$yn" != "y" ] && [ "$yn" != "N" ] && [ "$yn" != "n" ]
    do
        read -p "Please input [Y/N] : " yn
    done

    if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
        echo "$1 is reverting ......"
        echo 'wzdanzsm' | sudo -S tar -xjpP -f $1 > /dev/null 2>&1
        if [ $? == '0' ]; then
            echo "...... done! "        
        else
            echo "$1 revert failed"
        fi
    elif [ "$yn" == "N" ] || [ "$yn" == "n" ]; then
        echo "Ignore revert $1"
    else
        echo "Can't understand!"
    fi
}

if [ "$1" == '' ]; then 
    echo -e 'Please input the backup file you want to revert!\nExmple: revertBackup backup20160926.img'
    exit
fi


echo "Starting to revert!"
test -d ./.rvcache || mkdir ./.rvcache

echo 'wzdanzsm' | sudo -S tar -xj -f $1 -C ./.rvcache > /dev/null 2>&1

cd ./.rvcache

BFILE=`find ./ -name '*.bz2'`

for i in $BFILE
do
    rvt $i
done


echo "Revert mySQL data!"
read -p "Do you want to revert mysql data now? [Y/N] : " yn
while [ "$yn" != "Y" ] && [ "$yn" != "y" ] && [ "$yn" != "N" ] && [ "$yn" != "n" ]
do
    read -p "Please input [Y/N] : " yn
done

if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
    echo "Mysql data is reverting ......"
    mysql --defaults-file=./localhost.cnf < ./mysqlBack.sql 
    if [ $? == '0' ]; then
        echo '...... done!'
    else
        echo 'Mysql data revert failed!'
    fi
elif [ "$yn" == "N" ] || [ "$yn" == "n" ]; then
    echo "Ignore mysql revert!"
else
    echo "Can't understand input!"
fi

cd ..
rm -rf ./.rvcache
