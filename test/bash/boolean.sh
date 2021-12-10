#!/bin/bash 
# 提示： # 如果你不确定某个表达式的布尔值，可以用 if 结构进行测试。
echo
echo "Testing \"0\"" 

if [ 0 ]; then
	echo "0 is true." 
else
	echo "0 is false." 
fi # 0 为真。 

echo 
echo "Testing \"1\"" 
if [ 1 ]; then
	echo "1 is true." 
else
	echo "1 is false." 
fi # 1 为真。 

echo 
echo "Testing \"-1\"" 
if [ -1 ]; then
	echo "-1 is true." 
else
	echo "-1 is false." 
fi # -1 为真。 

echo 
echo "Testing \"NULL\"" 
if [ ] # NULL, 空 
then
	echo "NULL is true." 
else
	echo "NULL is false." 
fi # NULL 为假。

echo 
echo "Testing \"xyz\"" 
if [ xyz ] # 字符串 
then
	echo "Random string is true." 
else
	echo "Random string is false." 
fi # 随机字符串为真。 

echo 
echo "Testing \"$xyz\"" 
if [ $xyz ] # 原意是测试 $xyz 是否为空，但是 # 现在 $xyz 只是一个没有初始化的变量。 
then
	echo "Uninitialized variable is true." 
else
	echo "Uninitialized variable is flase." 
fi # 未初始化变量含有null空值，为假。 

echo 
echo "Testing \"-n \$xyz\"" 
if [ -n "$xyz" ] # 更加准确的写法。 
then
	echo "Uninitialized variable is true." 
else
	echo "Uninitialized variable is false." 
fi # 未初始化变量为假。 

echo xyz= # 初始化为空。 
echo "Testing \"-n \$xyz\"" 
if [ -n "$xyz" ]; then
	echo "Null variable is true." 
else
	echo "Null variable is false." 
fi # 空变量为假。 

echo # 什么时候 "false" 为真？ 
echo "Testing \"false\"" 
if [ "false" ] # 看起来 "false" 只是一个字符串 
then
	echo "\"false\" is true." #+ 测试结果为真。 
else
	echo "\"false\" is false." 
fi # "false" 为真。 

echo 
echo "Testing \"\$false\"" # 未初始化的变量。 
if [ "$false" ] 
then
	echo "\"\$false\" is true." 
else
	echo "\"\$false\" is false." 
fi # "$false" 为假。 # 得到了我们想要的结果。 # 如果测试空变量 "$true" 会有什么样的结果？ 

echo 
exit 0
