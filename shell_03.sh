#!/bin/bash

#--------------------------
# 随机生成8位密码
# 密码中包含[小写字母、大写字母、阿拉伯数字]
#--------------------------

Word=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789

for i in $(seq 8)
do
	Num=$[RANDOM%62]
	Pass=${Word:Num:1}
	PassWord=${PassWord}${Pass}
done

echo $PassWord
