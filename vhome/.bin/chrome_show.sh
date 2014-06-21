#!/bin/sh
#file   : chrome_show.sh
#author : ning
#date   : 2012-01-12 23:18:13


# example : 
#./chrome_show.sh 'Google'
#./chrome_show.sh 'a.html'


echo 'show window', $1

WID=`xdotool search "$1" | head -1`
xdotool windowactivate --sync $WID
xdotool key --clearmodifiers ctrl+l
xdotool key F5




