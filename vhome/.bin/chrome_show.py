#!/usr/bin/python
#coding: utf-8
#file   : chrome_show.py
#author : ning
#date   : 2012-03-09 00:34:19


import urllib, urllib2
import os, sys
import re, time
import logging
import webbrowser
import glob

localfile = sys.argv[1]

basename = os.path.basename( localfile )
basename = os.path.splitext(basename)[0]

dirname = os.path.dirname(localfile)
print 'dir: ', dirname


findpath = [
    '%s/%s*.html' % (dirname, basename), 
    '%s/../%s*.html' % (dirname, basename),
    '%s/../*/%s*.html' % (dirname, basename),
    '%s/../%s*.html' % (dirname, basename),
    '%s/../*/%s*.html' % (dirname, basename),
    '%s/../*/*/%s*.html' % (dirname, basename),
    '%s/../output/*/%s*.html' % (dirname, basename),
    '%s/../output/*/**/%s*.html' % (dirname, basename),
]

print 'find in: ', findpath

for p in findpath:
    for f in glob.glob(p) :
        #webbrowser.open(f)
        #os.system('chromium-browser "%s"' % f)
        cmd = 'opera -remote "openURL(%s)"' % f
        print cmd
        os.system(cmd)
        sys.exit(0)
        


#os.path.abspath(localfile)



