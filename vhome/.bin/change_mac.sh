sudo ifconfig eth0 down #关闭网卡
sudo ifconfig eth0 hw ether 00:AA:BB:CC:DD:EE #然后改地址
sudo ifconfig eth0 up #然后启动网卡
