

#批量转换src目录下的所有文件内容由GBK到UTF8
echo 'convert:', $1
cp -rf $1 $1_utf8
find $1 -type d -exec mkdir -p $1_utf8/{} \;
find $1 -type f -exec iconv -f GBK -t UTF8//IGNORE {} -o $1_utf8/{} \;


#rm -fr /tmp/utf8

#转换文件名由GBK为UTF8
#convmv -r -f cp936 -t utf8 --notest --nosmart *


#转换文件内容由GBK到UTF8
#iconv -f gbk -t utf8 $i > newfile
#批量转换文件内容由GBK到UTF8
#for i in `find . *`; do if [ -f "$i" ]; then iconv -f gb2312 -t utf8 $i > "./converted/$i" fi ; done
#转换 mp3 标签编码
#sudo apt-get install python-mutagen
#find . -iname '*.mp3' -execdir mid3iconv -e GBK {} \;
