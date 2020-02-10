#!/bin/bash

#--------------------------------------------------------
# Use awk instead of wc to count words, bytes, and lines
#--------------------------------------------------------

version=0.0.1

usage (){
cat <<EOF
Usage: $0 [OPTION]... [FILE]...

    -l, --lines		print the newline counts
    -c, --bytes		print the byte counts
    -w, --words		print the word counts
    -v, --version	print the $0 version
    -h, --help		display this help and exit
    
Desc:	Use awk instead of wc to count words, bytes, and lines
Ver:	$0 $version
Author:	ZHUANGZHUANG 
Date:	2020-02-09
Feat:	Combine short options
EOF
}

file=`getopt -o chwvl --long lines,bytes,words,help,version -n "$0" -- "$@"`

eval set -- "${file}"

while true
do
	case "$1" in
		-l|--lines)
			if [ $# -lt 3 ]; then
				bash $0 -h exit 1
			else
				shift 2
				for i in $@
				do
				awk 'END { print NR, "\t\t", FILENAME}' $i 2> /dev/null
				done
				echo "----------------------------"
				awk 'END { print NR, "\t\t total lines"}' $@ 2> /dev/null
			fi
			exit 0
			;;
		-c|--bytes)
			if [ $# -lt 3 ]; then
				bash $0 -h exit 1
			else
				shift 2
				for i in $@
				do
				awk '{ bytes += length($0) }; END { print bytes, "\t\t", FILENAME }' $i 2> /dev/null
				done
				echo "----------------------------"
				awk '{ bytes += length($0) }; END { print bytes "\t\t tatal bytes"}' $@ 2> /dev/null
			fi
			exit 0
			;;
		-w|--words)
			if [ $# -lt 3 ]; then
				bash $0 -h exit 1
			else
				shift 2
				for i in $@
				do
				awk '{ words += NF }; END { print words, "\t\t", FILENAME }' $i 2> /dev/null
				done
				echo "----------------------------"
				awk '{ words += NF }; END { print words "\t\t total words"}' $@ 2> /dev/null
			fi
			exit 0
			;;
		-h|--help)
			usage
			exit 0
			;;
		-v|--version)
			echo "$0 $version"
			exit 0
			;;
		*)
			bash $0 -h
			exit 1
	esac
done
exit 0
