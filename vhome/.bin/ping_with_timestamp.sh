#!/bin/sh
#file   : ping_with_timestamp.sh
#author : ning
#date   : 2013-05-26 21:41:19

ping 192.168.1.1 | awk '{print strftime("%Y-%m-%d %H:%M:%S "), $0 , system("")}'  >> ~/ping.log &



