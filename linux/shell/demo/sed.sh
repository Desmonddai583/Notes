#!/bin/bash
#

:<<'
查找
1. 打印/etc/passwd中第20行的内容
    sed -n '20p' /etc/passwd
2. 打印/etc/passwd中从第8行开始，到第15行结束的内容
    sed -n '8,15p' /etc/passwd 
3. 打印/etc/passwd中从第8行开始，然后+5行结束的内容
    sed -n '8,+5p' /etc/passwd
4. 打印/etc/passwd中开头匹配hdfs字符串的内容
    sed -n '/^hdfs/p' /etc/passwd
5. 打印/etc/passwd中开头为root的行开始，到开头为hdfs的行结束的内容
    sed -n '/^root/,/^hdfs/p' /etc/passwd
6. 打印/etc/passwd中第8行开始，到含有/sbin/nologin的内容的行结束内容
    sed -n '8,/\/sbin\/nologin/p' /etc/passwd
7. 打印/etc/passwd中第一个包含/bin/bash内容的行开始，到第5行结束的内容
    sed -n '/\/bin\/bash/,5p' /etc/passwd

需求描述：处理一个类似MySQL配置文件my.cnf的文本
编写脚本实现以下功能：
    输出文件有几个段，并且针对每个段可以统计配置参数总个数
预想输出结果：
    1: client 2
    2: server 12
    3: mysqld 12
    4: mysqld_safe 7
    5: embedded 8
    6: mysqld-5.5 9

    FILE_NAME=/root/lesson/5.6/my.cnf
    function get_all_segments
    {
        echo "`sed -n '/\[.*\]/p' $FILE_NAME  | sed -e 's/\[//g' -e 's/\]//g'`"
    }

    function count_items_in_segment
    {
        items=`sed -n '/\['$1'\]/,/\[.*\]/p' $FILE_NAME | grep -v "^#" | grep -v "^$" | grep -v "\[.*\]"`
        
        index=0
        for item in $items
        do
            index=`expr $index + 1`
        done

        echo $index

    }

    number=0

    for segment in `get_all_segments`
    do
        number=`expr $number + 1`
        items_count=`count_items_in_segment $segment`
        echo "$number: $segment  $items_count"
    done
'

:<<'
删除
1. 删除/etc/passwd中的第15行	
    sed -i '15d' /etc/passwd
2. 删除/etc/passwd中的第8行到第14行的所有内容	
    sed -i '8,14d' passwd
3. 删除/etc/passwd中的不能登录的用户(筛选条件：/sbin/nologin)	
    sed -i '/\/sbin\/nologin/d' passwd
4. 删除/etc/passwd中以mail开头的行，到以yarn开头的行的所有内容		
    sed -i '/^mail/,/^yarn/d' passwd
5. 删除/etc/passwd中第一个不能登录的用户，到第13行的所有内容
    sed -i '/\/sbin\/nologin/,13d' passwd
6. 删除/etc/passwd中第5行到以ftp开头的所有行的内容
    sed -i '5,/^ftp/d' passwd
7. 删除/etc/passwd中以yarn开头的行到最后行的所有内容
    # $符号表示最后一行
    sed -i '/^yarn/,$d' passwd

典型需求：
    1. 删除配置文件中的所有注释行和空行
        sed -i '/[:blank:]*#/d;/^$/d' nginx.conf
    2. 在配置文件中所有不以#开头的行前面添加*符号，注意：以#开头的行不添加
        sed -i 's/^[^#]/\*&/g' nginx.conf
'

:<<'
追加
    a
        1. passwd文件第10行后面追加"Add Line Behind"		
            sed -i '10a Add Line Begind' passwd
        2. passwd文件第10行到第20行，每一行后面都追加"Test Line Behind"
            sed -i '10,20a Test Line Behind' passwd
        3. passwd文件匹配到/bin/bash的行后面追加"Insert Line For /bin/bash Behind"
            sed -i '/\/bin\/bash/a Insert Line For /bin/bash Behind' passwd
    i 
        1. passwd文件匹配到以yarn开头的行，在匹配航前面追加"Add Line Before"
            sed -i '/^yarn/i Add Line Before' passwd
        2. passwd文件每一行前面都追加"Insert Line Before Every Line"
            sed -i 'i Insert Line Before Every Line' passwd
    r
        1. 将/etc/fstab文件的内容追加到passwd文件的第20行后面
            sed -i '20r /etc/fstab' passwd
        2. 将/etc/inittab文件内容追加到passwd文件匹配/bin/bash行的后面
            sed -i '/\/bin\/bash/r /etc/inittab' passwd
        3. 将/etc/vconsole.conf文件内容追加到passwd文件中特定行后面，匹配以ftp开头的行，到第18行的所有行
            sed -i '/^ftp/,18r /etc/vconsole.conf' passwd
    w
        1. 将passwd文件匹配到/bin/bash的行追加到/tmp/sed.txt文件中
            sed -i '/\/bin\/bash/w /tmp/sed.txt' passwd
        2. 将passwd文件从第10行开始，到匹配到hdfs开头的所有行内容追加到/tmp/sed-1.txt
            sed -i '10,/^hdfs/w /tmp/sed-1.txt' passwd
’   


:<<'
修改
    1. 修改/etc/passwd中第1行中第1个root为ROOT	
        sed -i '1s/root/ROOT/' passwd
    2. 修改/etc/passwd中第5行到第10行中所有的/sbin/nologin为/bin/bash
        sed -i '5,10s/\/sbin\/nologin/\/bin\/bash/g' passwd
    3. 修改/etc/passwd中匹配到/sbin/nologin的行，将匹配到行中的login改为大写的LOGIN
        sed -i '/\/sbin\/nologin/s/login/LOGIN/g' passwd
    4. 修改/etc/passwd中从匹配到以root开头的行，到匹配到行中包含mail的所有行。修改内为将这些所有匹配到的行中的bin改为HADOOP
        sed -i '/^root/,/mail/s/bin/HADOOP/g' passwd
    5. 修改/etc/passwd中从匹配到以root开头的行，到第15行中的所有行，修改内容为将这些行中的nologin修改为SPARK
        sed -i '/^root/,15s/nologin/SPARK/g' passwd
    6. 修改/etc/passwd中从第15行开始，到匹配到以yarn开头的所有航，修改内容为将这些行中的bin换位BIN
        sed -i '15,/^yarn/s/bin/BIN/g' passwd
'