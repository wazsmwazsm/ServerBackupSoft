#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin
export PATH

# define directory package function
function prcs() {
    # get input
    read -p "Do you want to create a backuop for $1 ? [Y/N] : " yn
    while [ "$yn" != "Y" ] && [ "$yn" != "y" ] && [ "$yn" != "N" ] && [ "$yn" != "n" ]
    do
        read -p "Please input [Y/N] : " yn
    done

    # do package
    if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
        echo "$1 is packaging ......"
        test -f "${1////_}.tar.bz2" && echo 'file already packaged!' && return
        echo 'wzdanzsm' | sudo -S tar cjP -f "${1////_}.tar.bz2" --exclude=/home/mrq/package/.pkcache/*  $1 > /dev/null 2>&1
        if [ $? == '0' ]; then
            echo "...... done! "        
        else
            echo "$1 package failed"
        fi
    elif [ "$yn" == "N" ] || [ "$yn" == "n" ]; then
        echo "Ignore $1 ..."
    else
        echo "I don't understand this!"
        exit
    fi
} 

echo "Starting to backup!"

echo "backing up system files!"
# create file cache
test -d ./.pkcache || mkdir ./.pkcache
cd ./.pkcache

# process sys file backup
prcs /boot 
prcs /home
prcs /root
prcs /etc
prcs /var/www

echo "backing up Web configure!"
test -d ./webcnf || mkdir ./webcnf
cd ./webcnf
prcs /usr/local/http2/conf
prcs /usr/local/php/lib/php.ini
prcs /etc/my.cnf
cd ..


# mysql data package

# copy mysql login file
test -f ../localhost.cnf && echo "Loding mysql config file" || echo "~localhost.cnf not exit, try create it."
cp ../localhost.cnf ./

echo "backing up mySQL data!"
read -p "Do you want to create a backuop for mysql data ? [Y/N] : " yn
while [ "$yn" != "Y" ] && [ "$yn" != "y" ] && [ "$yn" != "N" ] && [ "$yn" != "n" ]
do
    read -p "Please input [Y/N] : " yn
done

if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
    echo "Mysql data is packaging ......"
    mysqldump --defaults-file=./localhost.cnf --all-databases > ./mysqlBack.sql 
    if [ $? == '0' ]; then
        echo '...... done!'
    else
        echo 'Mysql data package failed!'
    fi
elif [ "$yn" == "N" ] || [ "$yn" == "n" ]; then
    echo "Ignore mysql data!"
else
    echo "Can't understand input!"
fi


# package all backup files to a tar img
echo "Packaging all backup files....."
echo 'wzdanzsm' | sudo -S tar -cj -f "../backup$(date +%Y%m%d).img"  ./*
if [ $? == '0' ]; then
    echo "Package done! Thank you for use!"
    # clean cache files
    cd ..
    rm -rf ./.pkcache
else
    echo "ERROR: can't package all files!"
fi









