#!/usr/bin/python
#--coding:utf8--
# * * * * *  /home/ning/.bin/vpn_monitor_no_svn.py

import sys, os, glob, logging

logging.basicConfig(filename='/tmp/vps_monitor.log', level=logging.DEBUG, format= "%(asctime)-15s %(levelname)s  %(message)s")


def system(cmd):
    logging.debug(cmd)
    import commands
    return commands.getoutput(cmd)



def main():
    rst = system('curl -v --connect-timeout 3 http://www.xiaonei.com/')
    if rst.find('nginx') <= 0: # no network
        logging.info('no network')
        return 
    rst = system('curl -v --connect-timeout 3 --socks5 127.0.0.1:9527 http://www.xiaonei.com/')
    if rst.find('nginx') > 0: # ok
        logging.info('vps ok , return ')
        return 
    logging.info('restart vps')
    system('kill -9 $( lsof -i:9527  -sTCP:LISTEN -t )')
    system('killall -9 autossh')
    system('autossh -Nf -D 0.0.0.0:9527 root@184.82.5.125')
        
main()        
    
        


