#!/bin/sh
#file   : updateall.sh
#author : ning
#date   : 2012-10-19 13:20:47


cd bundle

for i in `ls ./` ; do 
    if [ -d $i ]; then
        echo "status: $i"
        cd $i && git st && cd ..
    fi
done ;

cd ..
