#!/bin/bash
#

:<<'
格式符示例：
1、以字符串格式打印/etc/passwd中的第7个字段，以":"作为分隔符
    awk 'BEGIN{FS=":"} {printf "%s",$7}' /etc/passwd
2、以10进制格式打印/etc/passwd中的第3个字段，以":"作为分隔符
    awk 'BEGIN{FS=":"} {printf "%d\n",$3}' /etc/passwd
3、以浮点数格式打印/etc/passwd中的第3个字段，以":"作为分隔符
    awk 'BEGIN{FS=":"} {printf "%0.3f\n",$3}' /etc/passwd
4、以16进制数格式打印/etc/passwd中的第3个字段，以":"作为分隔符
    awk 'BEGIN{FS=":"} {printf "%#x\n",$3}' /etc/passwd
5、以8进制数格式打印/etc/passwd中的第3个字段，以":"作为分隔符
    awk 'BEGIN{FS=":"} {printf "%#o\n",$3}' /etc/passwd
6、以科学计数法格式打印/etc/passwd中的第3个字段，以":"作为分隔符
    awk 'BEGIN{FS=":"} {printf "%e\n",$3}' /etc/passwd
'

:<<'
RegExp匹配
匹配/etc/passwd文件行中含有root字符串的所有行
    awk 'BEGIN{FS=":"}/root/{print $0}' /etc/passwd
匹配/etc/passwd文件行中以yarn开头的所有行
    awk 'BEGIN{FS=":"}/^yarn/{print $0}' /etc/passwd
'

:<<'
关系运算符匹配
1. 以:为分隔符，匹配/etc/passwd文件中第3个字段小于50的所有行信息
    awk 'BEGIN{FS=":"}$3<50{print $0}' /etc/passwd
2. 以:为分隔符，匹配/etc/passwd文件中第3个字段大于50的所有行信息
    awk 'BEGIN{FS=":"}$3>50{print $0}' /etc/passwd
3. 以:为分隔符，匹配/etc/passwd文件中第7个字段为/bin/bash的所有行信息
    awk 'BEGIN{FS=":"}$7=="/bin/bash"{print $0}' /etc/passwd
4. 以:为分隔符，匹配/etc/passwd文件中第7个字段不为/bin/bash的所有行信息
    awk 'BEGIN{FS=":"}$7!="/bin/bash"{print $0}' /etc/passwd
5. 以：为分隔符，匹配/etc/passwd中第3个字段包含3个以上数字的所有行信息
    awk 'BEGIN{FS=":"}$3~/[0-9]{3,}/{print $0}' /etc/passwd
'

:<<'
关系运算符匹配
1. 以:为分隔符，匹配/etc/passwd文件中包含hdfs或yarn的所有行信息
    awk 'BEGIN{FS=":"}$1=="hdfs" || $1=="yarn" {print $0}' /etc/passwd
2. 以:为分隔符，匹配/etc/passwd文件中第3个字段小于50并且第4个字段大于50的所有行信息
    awk 'BEGIN{FS=":"}$3<50 && $4>50 {print $0}' /etc/passwd
'

:<<'
动作中的表达式
1. 使用awk计算/etc/services中的空白行数量
    awk '/^$/{sum++}END{print sum}' /etc/services
2. 计算学生课程分数平均值，学生课程文件内容如下：
    Allen	80	90	96	98
    Mike	93	98	92	91
    Zhang	78	76	87	92
    Jerry	86	89	68	92
    Han		85	95	75	90
    Li		78	88	98	100
    awk 'BEGIN{printf "%-8s%-8s%-8s%-8s%-8s%s\n","Name","Yuwen","Math","English","Pysical","Average"}{total=$2+$3+$4+$5;AVG=total/4;printf "%-8s%-8d%-8d%-8d%-8d%0.2f\n",$1,$2,3,$4,$5,AVG}' student.txt
'

:<<'
条件循环
1. 以:为分隔符，只打印/etc/passwd中第3个字段的数值在50-100范围内的行信息
    scripts.awk
        BEGIN{
            FS=":"
        }
        {
            if($3<50)
            {
                printf "%-20s%-25s%-5d\n","UID<50",$1,$3
            }
            else if($3>50 && $3<100)
            {
                printf "%-20s%-25s%-5d\n","50<UID<100",$1,$3
            }
            else
            {
                printf "%-20s%-25s%-5d\n","UID>100",$1,$3
            }
        }
    awk -f scripts.awk /etc/passwd
2. 计算下列每个同学的平均分数，并且只打印平均分数大于90的同学姓名和分数信息
    Name	Chinese		English		Math		Physical	Average
    Allen	80			90			96			98
    Mike	93			98			92			91
    Zhang	78			76			87			92
    Jerry	86			89			68			92
    Han		85			95			75			90
    Li		78			88			98			100	
    scripts.awk
        BEGIN{
           printf "%-10s%-10s%-10s%-10s%-10s%s-10s\n","Name","Chinese","English","Math","Pysical","Average"
        }
        {
            total=$2+$3+$4+$5;
            avg=total/4;
            if(avg>90) 
            {
                printf "%-10s%-10d%-10d%-10d%-10d%-0.2f\n",$1,$2,3,$4,$5,avg
                score_chinese+=$2
                score_english+=$3
                score_math+=$4
                score_physical+=$5
            }
        } 
        END{
            printf "%-10s%-10d%-10d%-10d%-10d\n","",score_chinese,score_english,score_math,score_physical
        }
    awk -f scripts.awk /etc/passwd
'

:<<'
字符串函数
1. 以:为分隔符，返回/etc/passwd中每行中每个字段的长度	
    root:x:0:0:root:/root:/bin/bash
    4:1:1:1:4:5:9
    代码：
    BEGIN{
        FS=":"
    }
    
    {
        i=1
        while(i<=NF)
        {
            if(i==NF)
                printf "%d",length($i)
            else
                printf "%d:",length($i)
            i++
        }
        print ""
    }
2. 搜索字符串"I have a dream"中出现"ea"子串的位置	
    1. awk 'BEGIN{str="I hava a dream";location=index(str,"ea");print location}'
    2. awk 'BEGIN{str="I hava a dream";location=match(str,"ea");print location}'
3. 将字符串"Hadoop is a bigdata Framawork"全部转换为小写
    awk 'BEGIN{str="Hadoop is a bigdata Framework";print tolower(str)}'
4. 将字符串"Hadoop is a bigdata Framawork"全部转换为大写
    awk 'BEGIN{str="Hadoop is a bigdata Framework";print toupper(str)}'
5. 将字符串"Hadoop Kafka Spark Storm HDFS YARN Zookeeper"，按照空格为分隔符，分隔每部分保存到数组array中
    awk 'BEGIN{str="Hadoop Kafka Spark Storm HDFS YARN Zookeeper";split(str,arr);for(a in arr) print arr[a]}'
6. 搜索字符串"Tranction 2345 Start:Select * from master"第一个数字出现的位置
    awk 'BEGIN{str="Tranction 2345 Start:Select * from master";location=match(str,/[0-9]/);print location}'
7. 截取字符串"transaction start"的子串，截取条件从第4个字符开始，截取5位
    awk 'BEGIN{str="transaction start";print substr(str,4,5)}'
    awk 'BEGIN{str="transaction start";print substr(str,4)}'
8. 替换字符串"Tranction 243 Start,Event ID:9002"中第一个匹配到的数字串为$符号
    awk 'BEGIN{str="Tranction 243 Start,Event ID:9002";count=sub(/[0-9]+/,"$",str);print count,str}'
    awk 'BEGIN{str="Tranction 243 Start,Event ID:9002";count=gsub(/[0-9]+/,"$",str);print count,str}'
'

:<<'
awk中数组
1. 统计主机上所有的TCP连接状态数，按照每个TCP状态分类
    netstat -an | grep tcp | awk '{array[$6]++}END{for(a in array) print a,array[a]}'
2. 计算横向数据总和，计算纵向数据总和
    allen	80	90	87	91	348
    mike	78	86	93	96	256
    Kobe	66	92	82	78	232
    Jerry	98	74	66	54  356
    Wang	87	21	100	43  322
            234 342 451 456 
    
    BEGIN {
        printf "%-10s%-10s%-10s%-10s%-10s%-10s\n","Name","Yuwen","Math","English","Physical","Total"
    }
    {
        total=$2+$3+$4+$5
        yuwen_sum+=$2
        math_sum+=$3
        eng_sum+=$4
        phy_sum+=$5
        printf "%-10s%-10d%-10d%-10d%-10d%-10d\n",$1,$2,$3,$4,$5,total
    }
    END {
        printf "%-10s%-10d%-10d%-10d%-10d\n","",yuwen_sum,math_sum,eng_sum,phy_sum
    }
'

:<<'
需求描述：利用awk处理日志，并生成结果报告
生成数据脚本insert.sh,内容如下：
	#!/bin/bash
	#
	
	function create_random()
	{
		min=$1
		max=$(($2-$min+1))
		num=$(date +%s%N)
		echo $(($num%$max+$min))
	}
	
	INDEX=1
	
	while true
	do
		for user in Allen Mike Jerry Tracy Hanmeimei Lilei
		do
			COUNT=$RANDOM
			NUM1=`create_random 1 $COUNT`
			NUM2=`expr $COUNT - $NUM1`		
			echo "`date '+%Y-%m-%d %H:%M:%S'` $INDEX Batches:$user INSERT $COUNT DATA INTO database.table 'test',Insert $NUM1 Records Successfully,Failed Insert $NUM2 Records" >> /root/db.log.`date +%Y%m%d`
			INDEX=`expr $INDEX + 1`
		done
	done
	
	数据格式如下：
	2019-01-29 00:58:30 1 Batches: user allen insert 22498 records into database:product table:detail, insert 20771 records successfully,failed 1727 records
	2019-01-29 00:58:30 2 Batches: user mike insert 29378 records into database:product table:detail, insert 21426 records successfully,failed 7952 records
	2019-01-29 00:58:30 3 Batches: user jerry insert 22779 records into database:product table:detail, insert 9397 records successfully,failed 13382 records
	2019-01-29 00:58:30 4 Batches: user tracy insert 25232 records into database:product table:detail, insert 21255 records successfully,failed 3977 records
1. 统计每个人员分别插入了多少条record进数据库
    输出结果：
        USER	Total_Records
        allen	493082
        mike	349287
    代码
        BEGIN {
            printf "%-10s%-20s\n","User","Total Records"
        }
        
        {
            USER[$6]+=$8
        }
        
        END {
            for(u in USER)
                printf "%-10s%-20d\n", u,USER[u]
        }
2. 统计每个人分别插入成功了多少record，失败了多少record
    输出结果:
        User 	Sucess_Record		Failed_Records
        jerry	3472738				283737
        mike	2738237				28373
    
    代码
        BEGIN {
            printf "%-10s%-20s%-20s\n","User","Sucess_Records","Failed_Records"
        }
        
        {
            SUCCESS[$6]+=$14
            FAIL[$6]+=$17
        }
        
        END {
            for(u in SUCCESS)
                printf "%-10s%-20d%-20d\n",u,SUCCESS[u],FAIL[u]
        }
3. 将例子1和例子2结合起来，一起输出，输出每个人分别插入多少数据，多少成功，多少失败，并且要格式化输出，加上标题
    输出结果：
		User      Total               Sucess              Failed              
		tracy     7472277             3945659             3526618             
		allen     7390330             3597157             3793173             
		mike      7226579             3679395             3547184
		
	代码：
		BEGIN {
			printf "%-10s%-20s%-20s%-20s\n","User","Total","Sucess","Failed"
		}
		
		{
			TOTAL[$6]+=$8
			SUCCESS[$6]+=$14
			FAIL[$6]+=$17
		}
		
		END {
			for(u in SUCCESS)
				printf "%-10s%-20d%-20d%-20d\n",u,TOTAL[u],SUCCESS[u],FAIL[u]
		}
4. 在例子3的基础上，加上结尾，统计全部插入记录数，成功记录数，失败记录数
    输出结果：
		User      Total               Sucess              Failed              
		tracy     7472277             3945659             3526618             
		allen     7390330             3597157             3793173             
		mike      7226579             3679395             3547184
				  21384945			
				  
	代码：
        BEGIN {
            printf "%-10s%-20s%-20s%-20s\n","User","Total","Sucess","Failed"
        }
        
        {
            TOTAL[$6]+=$8
            SUCCESS[$6]+=$14
            FAIL[$6]+=$17
        }
        
        END {
            for(u in SUCCESS)
            {
                total+=TOTAL[u]
                success+=SUCCESS[u]
                fail+=FAIL[u]
                printf "%-10s%-20d%-20d%-20d\n",u,TOTAL[u],SUCCESS[u],FAIL[u]
            }
        
            printf "%-10s%-20d%-20d%-20d\n","",total,success,fail
        }
5. 查找丢失数据的现象，也就是成功+失败的记录数，不等于一共插入的记录数。找出这些数据并显示行号和对应行的日志信息
    awk '{if($8!=$14+$17) print NR,$0}' db.log.201901
'