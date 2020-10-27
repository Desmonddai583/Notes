#!/bin/bash
#

:<<'
需求描述：写一个监控nginx的脚本；如果Nginx服务宕掉，则该脚本可以检测到并将进程启动；如果正常运行，则不做任何处理
'

this_pid=$$

function nginx_daemon
{
    status=$(ps -ef | grep -v $this_pid | grep nginx | grep -v grep &> /dev/null)
    if [ $? -eq 1 ];then
        systemctl start nginx && echo "Start Nginx Successful" || echo "Failed To Start Nginx"
    else
        echo "Nginx is RUNNING Well"
        sleep 5
    fi
}

while true
do
    nginx_daemon
done

:<<'
在终端命令行定义函数
在脚本中定义好disk_usage函数，然后直接使用. test.sh，再使用declare -F查看，是否可以列出disk_usage函数
'

function disk_usage
{
    if [ $# -eq 0 ];then
        df
    else
        case $1 in
            -h)
                df -h
                ;;
            -i)
                df -i
                ;;
            -ih|-hi)
                df -ih
                ;;
            -T)
                df -T
                ;;
            *)
                echo "Usage: $0 { -h|-i|-ih|-T }"
                ;;
        esac
    fi
}

:<<'
写一个脚本，该脚本可以实现计算器的功能，可以进行+-*/四种计算
例如：sh calculate.sh 30 + 40 | sh calculate.sh 30 - 40 | sh calculate.sh 30 * 40
'

function calculate
{
    case "$2" in
        +)
            echo "$1 + $3 = $(expr $1 + $3)"
            ;;
        -)
            echo "$1 + $3 = $(expr $1 - $3)"
            ;;
        \*)			
            echo "$1 * $3 = $(expr $1 \* $3)"
            ;;
        /)
            echo "$1 / $3 = $(expr $1 / $3)"
            ;;
    esac
}

calculate $1 $2 $3

:<<'
返回Linux上所有的不可登陆用户
'

function get_users
{
    echo `cat /etc/passwd | awk -F: '/\/sbin\/nologin/{print $1}'`
}

index=1
for user in `get_users`;do
    echo "The $index user is $user"
    index=$(expr $index + 1)
done	

echo
echo "System have $index users(do not login)"