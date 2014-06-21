
dpkg --get-selections | grep -v deinstall 


#备份当前系统安装的所有包的列表
#dpkg --get-selections | grep -v deinstall > ~/somefile
#从上面备份的安装包的列表文件恢复所有包
#dpkg --set-selections < ~/somefile
#sudo dselect
