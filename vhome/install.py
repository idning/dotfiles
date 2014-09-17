#!/usr/bin/python
import glob, os, sys, time

from subprocess import *

def system(cmd):
    print cmd
    p = Popen(cmd, shell=True, bufsize = 102400, stdout=PIPE)
    p.wait()
    rst = p.stdout.read()
    #print rst
    return rst



files = glob.glob('.*')

if '.git' in files:
    files.remove('.git')
if '.svn' in files:
    files.remove('.svn')

print files

for f in files:
    thispath = os.path.abspath(f)
    homepath = os.path.expanduser('~/'+f)
    if os.path.exists(homepath):
        system ('mv %s /tmp'% homepath)
    system("ln -s %s %s "%(thispath, homepath))

print 'please run '
print 'vim +BundleInstall +qall'
