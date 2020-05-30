#!/bin/bash

#---------------------------------
# 天气查询
#---------------------------------

wttr(){
	local request="wttr.in/${1-Paris}"
	[ "$(tput cols)" -lt 125   ] && request+='?n'
	curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"

}

wttr Beijing
# alias get_weather='curl -H "Accept-Language: zh" --compressed wttr.in'
