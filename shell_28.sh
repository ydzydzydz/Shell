#!/bin/bash

returncode=0
while [ "$returncode" != "1" ]; do
	exec 3>&1
	menu_result=`dialog --clear --title "Dialog Example" \
		--menu "MENU" 10 50 6 \
		1 "Text" \
		2 "Form" \
		3 "Exit" \
		2>&1 1>&3`
	returncode=$?
	exec 3>&-

	case $menu_result in
		1)
			dialog --ok-label "BACK" --msgbox "text" 8 30
			;;
		2)
			init_input=`mktemp`
			dialog --title "Title" \
			       --form "Form-title"	12 40 5 \
				"port: " 1 1 "13254" 1 7 6 5 \
				"psk:  " 3 1 "" 3 7 15 15 \
				"obfs: " 5 1 "" 5 7 6 4 2>$init_input
			if [ $? -eq 0 ]; then
				PORT=`sed -ne '1p' $init_input`
				PSK=`sed -ne '2p' $init_input`
				OBFS=`sed -ne '3p' $init_input`

				echo "[snell-server]
				listen = 0.0.0.0:$PORT
				psk = $PSK
				obfs = $OBFS" > abc.txt
			fi
			rm -f $init_input
			;;
		3|*)
			clear
			exit 1
			;;
	esac
done
