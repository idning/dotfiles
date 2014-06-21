#!/bin/sh
#file   : restartnetworking.sh
#author : ning
#date   : 2013-01-24 15:47:25

#参考 http://askubuntu.com/questions/240427/chrome-flash-sound-gets-broken-and-only-a-system-restart-fixes-it
killall pulseaudio

#sudo /etc/init.d/pulseaudio restart

#lsof | grep pcm


#http://askubuntu.com/questions/230888/is-there-another-way-to-restart-the-sound-system-if-pulseaudio-alsa-dont-work
#pulseaudio -k && sudo alsa force-reload
