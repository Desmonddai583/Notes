#!/bin/bash
#

:<<'
mysql命令参数详解：
    -u	用户名
    -p	用户密码
    -h	服务器IP地址
    -D	连接的数据库
    -N	不输出列信息
    -B	使用tab键代替默认交互分隔符,-B一定要放在所有选项最后
    -e	执行SQL语句
    
    其他选项
    -E	垂直输出
    -H	以HTML格式输出
    -X	以XML格式输出
'

:<<'
写一个脚本，该脚本可以接收二个参数，参数为需要执行的SQL语句
sh operate_mysql.sh school "SELECT * FROM student"

user="dbuser"
password="123456"
host="192.168.184.132"
db_name="$1"

SQL="$2"

mysql -u"$user" -p"$password" -h"$host" -D"$1" -B -e "$SQL"
'

:<<'
查询MySQL任意表的数据，并将查询到的结果保存到HTML文件中

mysql -u"$user" -p"$password" -h"$host" -D"$1" -H -B -e "$SQL"
'

:<<'
查询MySQL任意表的数据，并将查询到的结果保存到XML文件中

mysql -u"$user" -p"$password" -h"$host" -D"$1" -X -B -e "$SQL"
'

:<<'
如何将文本中格式化的数据导入到MySQL数据库中？
    需求1：处理文本中的数据，将文本中的id大于1014的数据插入MySQL中			
        1010	jerry	1991-12-13	male
        1011	mike	1991-12-13	female
        1012	tracy	1991-12-13	male
        1013	kobe	1991-12-13	male
        1014	allen	1991-12-13	female
        1015	curry	1991-12-13	male
        1016	tom		1991-12-13	female

        user="dbuser"
        password="123456"
        host="192.168.184.132"

        mysql_conn="mysql -u"$user" -p"$password" -h"$host""

        cat data.txt | while read id name birth sex
        do
            if [ $id -gt 1014 ];then
                $mysql_conn -e "INSERT INTO school.student1 values('$id','$name','$birth','$sex')"
            fi
        done
        
    需求2：
        2021||hao||1989-12-21||male
        2022||zhang||1989-12-21||male
        2023||ouyang||1989-12-21||male
        2024||li||1989-12-21||female

        user="dbuser"
        password="123456"
        host="192.168.184.132"

        mysql_conn="mysql -u'$user' -p'$password' -h'$host'"

        IFS="||"

        cat data-2.txt | while read id name birth sex
        do
            mysql -u"$user" -p"$password" -h"$host" -e "INSERT INTO school.student2 values('$id','$name','$birth','$sex')"
        done
'

:<<'
备份MySQL中的库或表
    mysqldump
        常用参数详解：
        -u		用户名
        -p		密码
        -h		服务器IP地址
        -d		等价于--no-data		只导出表结构
        -t		等价于--no-create-info	只导出数据，不导出建表语句
        -A		等价于--all-databases
        -B		等价于--databases	导出一个或多个数据库
    
    需求：将school中的score表备份，并且将备份数据通过FTP传输到192.168.184.3的/data/backup目录下
        FTP常用指令：
            open		与FTP服务器建立连接，例子：open 192.168.184.3
            user		有权限登录FTP服务器的用户名和密码，例子：user ftp_user redhat

        db_user="dbuser"
        db_password="123456"
        db_host="192.168.184.132"

        ftp_user="ftp_user"
        ftp_password="redhat"
        ftp_host="192.168.184.3"

        dst_dir="/data/backup"
        time_date="`date +%Y%m%d%H%M%S`"
        file_name="school_score_${time_date}.sql"

        function auto_ftp
        {
            ftp -niv << EOF
                open $ftp_host
                user $ftp_user $ftp_password

                cd $dst_dir
                put $1
                bye
        EOF
        }

        mysqldump -u"$db_user" -p"$db_password" -h"$db_host" school score > ./$file_name && auto_ftp ./$file_name
'