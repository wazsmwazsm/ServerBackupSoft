#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin
export PATH

echo 'wzdanzsm' | sudo -S tar -xj -f $1 -C ./.rvcache > /dev/null 2>&1

ls ./.rvcache
