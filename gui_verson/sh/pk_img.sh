#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin
export PATH
# 因为是C程序调用的次脚本，所以此时运行的当前路径为C程序的执行路径
cd ./.pkcache
echo 'wzdanzsm' | sudo -S tar -cj -f "../backup$(date +%Y%m%d).img"  ./*
if [ $? == '0' ]; then
    echo "done"
    cd ..
    rm -rf ./.pkcache
else
    echo "failed"
fi
