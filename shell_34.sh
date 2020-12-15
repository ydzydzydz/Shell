#!/bin/bash

#--------------------------------
# select 脚本练习
#--------------------------------

function diskspace(){
	df -h
}

function whoseon (){
	who
}

function memusage(){
	cat /proc/meminfo
}

PS3="Enter option: "

select selection in \
	"Display disk sapce" \
	"Display loged on users" \
	"Display memory usage" \
	"Exit program"
do
	clear
	case $selection in
		"Display disk sapce")
			diskspace;;
		"Display loged on users")
			whoseon;;
		"Display memory usage")
			memusage;;
		"Exit program")
			break;;
		*)
			echo "Sorry, wrong selection"
	esac
done











