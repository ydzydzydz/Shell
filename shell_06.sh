#!/bin/bash

#-------------------------
# 输入秒数，倒计时
#-------------------------

echo0 (){ echo "
000000000
00     00
00     00
00     00
00     00
00     00
00     00
00     00
000000000
"
}

echo1 (){ echo "
    11
   111
 11111
    11
    11
    11
    11
    11
111111111
"
}


echo2 (){ echo "
222222222
       22
       22
       22
222222222
22
22
22
222222222
"
}


echo3 (){ echo "
333333333
       33
       33
       33
333333333
       33
       33
       33
333333333
"
}


echo4 (){ echo "
44     44
44     44
44     44
44     44
444444444
       44
       44
       44
       44
"
}


echo5 (){ echo "
555555555
55
55
55
555555555
       55
       55
       55
555555555
"
}


echo6 (){ echo "
666666666
66
66
66
666666666
66     66
66     66
66     66
666666666
"
}


echo7 (){ echo "
777777777
      77
     77
    77
    77
    77
    77
    77
    77
"
}


echo8 (){ echo "
888888888
88     88
88     88
88     88
888888888
88     88
88     88
88     88
888888888
"
}


echo9 (){ echo "
999999999
99     99
99     99
99     99
999999999
       99
       99
       99
999999999
"
}


Ling=0
read -p "[分钟]:" Fen; Miao=$[Fen*60]
tput civis
for ((i=$Miao;i>=0;i--))
	do
		clear
		if [ "$i" -eq 0 ]; then
			echo -e "\033[31m00:00:00\033[0m"
		else
			let Hour=$[i/3600]; let Minuite=$[i/60]; let Second=$[$i%60]
			if [ "$Hour" -lt 10 ];then
				Hour=$Ling$Hour
			fi
			if [ "$Minuite" -lt 10 ];then
				Minuite=$Ling$Minuite
			fi
			if [ "$Second" -lt 10 ];then
				Second=$Ling$Second
			fi
			echo -e "\033[32m$Hour:$Minuite:$Second\033[0m"
			sleep 1
		fi
	done
