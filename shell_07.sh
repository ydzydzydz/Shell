tput civis
while [ 1 ]  
do 
	nonth=$(date +%B)  
	case "$nonth" in  
		January)  nonth=1;;  
		February)  nonth=2;;  
		March)  nonth=3;;  
		April)  nonth=4;;  
		May)  nonth=5;;  
		June)  nonth=6;;  
		July)  nonth=7;;  
		August)  nonth=8;;  
		September)  nonth=9;;  
		October)  nonth=10;;  
		November)  nonth=11;;  
		December)  nonth=12;;  
	esac  
	tput clear  
	tput cup 3 10  
	echo $(date +%Y)--$nonth--$(date +%d) $(date +%H):$(date +%M):$(date +%S) $(date +%A)  
	sleep 1  
	done 
