#!/usr/bin/python
#--coding:utf8--
#批量转换src目录下的所有文件内容由GBK到UTF8

import sys, os, glob

def system(cmd):
    print cmd
    import commands
    return commands.getoutput(cmd)

def conv(fname):
    print 'conv(%s):' % fname 
    fin = file(fname)
    fout = file(fname + '.t', 'w')

    for i in file(fname):
        print >> fout, i.decode('gbk', 'replace').encode('utf8'),
    system('mv %s %s' % (fname, fname+'~'))
    system('mv %s %s' % (fname+'.t', fname))

def convdir(dirname):
    dirname = os.path.abspath(dirname) + '/'
    print 'convdir(%s):' % dirname
    if os.path.basename(dirname) == '.svn': 
       return 
    for f in os.listdir(dirname): # glob.glob(dirname + '*'):
        f = dirname + f 
        print f
        if (os.path.isdir(f)): 
            convdir(f)
        elif (f.endswith('~')): 
            continue
        else :
            conv(f)
    

def main():
    if (len(sys.argv) < 2): 
        print 'gbk_utf8_convert.py file|dir'
        return
    if (os.path.isdir(sys.argv[1])):
        convdir(sys.argv[1])
    else:
        conv(sys.argv[1])
        
main()        
    
        


