#!/bin/sh
#file   : restartnetworking.sh
#author : ning
#date   : 2013-01-24 15:47:25

sudo modprobe -r iwlagn  
sudo modprobe -r iwlcore 
sudo modprobe -r cfg80211 
sudo modprobe -r mac80211  

sudo modprobe  iwlagn  
sudo modprobe  iwlcore 
sudo modprobe  mac8021 
sudo modprobe  cfg80211

#sudo /sbin/ifconfig wlan0 down
#sudo /sbin/ifconfig wlan0 hw ether 8c:a9:81:7a:9b:f0
#sudo /sbin/ifconfig wlan0 up
#restartnetworking 


sudo service network-manager restart
