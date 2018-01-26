#!/bin/bash

echo "Shell 传递参数实例！"
echo "\$0表示执行的文件名：$0"
echo "\$1表示第一个参数为：$1"
echo "\$2表示第二个参数为：$2"
echo "\$3表示第三个参数为：$3"
echo "\$#表示传递到脚本的参数个数: $#"
echo "\$$脚本当前运行进程号: $$"
echo "\$!后台运行的最后一个进程的ID号: $!"
echo "\$*以单字符串显示所有参数: $*"
echo "\$@返回每个参数: $@"
echo "\$-显示shell当前使用的选项: $-"
echo "\$?显示命令退出状态: $?"

echo "--------------read命令-------------------"
read -p "随意输入若干字符：" name
[ -z "${name}" ] && name="不输入内容默认输出该行"
echo -e "$name"
echo -e "china \c"
echo -e "Hello"

echo "----------------\$*输出------------------"
for i in "$*";do
echo $i
done
echo "----------------\$@输出------------------"
for i in "$@";do
echo $i
done

# echo "-----------------数组--------------------"
# array_name=(
# value0
# value11
# value222
# 123456789
# )
# echo ${#array_name[@]}
# echo ${#array_name[3]}
# echo ${array_name[index+1]}

# echo "------------------运算符-----------------"
# expr length "hello"
# expr 2 + 1
# expr 2 != 1
# expr 2 != 2

# echo "---------------readonly-----------------"
# file="/var/log"
# readonly file
# if [ -r $file ]
# then
#     echo "可读"
# else
#     echo "不可读"
# fi

# if [ -w $file ]
# then
#     echo "可写"
# else
#     echo "不可写"
# fi

# echo "-------------------循环------------------"
# int=1
# while(($int<=3))
# do
# echo $int
# let "int++"
# # let "int+=10"
# done

# echo "-----------------let--------------------"
# let "t1 = ((a = 5 + 3, b = 7 - 1, c = 15 - 1))"
# echo "t1 = $t1, a = $a, b = $b"
# echo "----------------无限循环-----------------"
# while :
# do
#     command
# done  