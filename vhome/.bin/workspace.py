#!/usr/bin/env python
#coding: utf-8
#file   : workspace.py
#author : ning
#date   : 2013-11-09 18:06:20

import urllib, urllib2
import os, sys
import re, time
import logging
import argparse
import commands
from string import Template

from argparse import RawTextHelpFormatter

from pcl import common

def TT(template, args): #todo: modify all
    return Template(template).substitute(args)

def cmd(cmd):
    print cmd
    #print cmd.replace('\n', '')
    return common.system(cmd.replace('\n', ' '))

def cmd2(cmd):
    for line in cmd.split('\n'):
        line = line.strip()
        if not line:
            continue
        print line
        print common.system(line)

def _tmux_exists(title):
    status, output = commands.getstatusoutput('tmux has-session -t %s' % title)
    return status == 0

def task(func):
    func.attr = 'task'
    return func

##############################################################################################################
##############################################################################################################
##############################################################################################################


@task
def mongo():
    cmd('''
gnome-terminal --geometry=120x40
--tab --working-directory ~/idning/blog_and_notes
--tab --working-directory ~/idning/blog_and_notes
--tab --working-directory ~/idning/blog_and_notes
--tab --working-directory ~/idning-github/mongo/src/mongo
--tab --working-directory ~/idning-github/mongo/src/mongo
''')


@task
def tokumx():
    cmd('''
gnome-terminal --geometry=120x40
--tab --working-directory ~/idning/blog_and_notes
--tab --working-directory ~/idning/blog_and_notes
--tab --working-directory ~/idning-github/tokumx/mongo/src/mongo/
--tab --working-directory ~/idning-github/tokumx/mongo/src/third_party/ft-index/
''')


@task
def read():

    _start_or_attach('read', '''
        tmux new -d      -s read    -n note     -c ~/idning/blog_and_notes/
        tmux new-window  -t read:   -n mongo    -c ~/idning-source/c/mongodb-src-r2.0.6/
        tmux new-window  -t read:   -n lighttpd -c ~/idning-source/c/lighttpd-1.5.0.read/
        tmux new-window  -t read:   -n nginx    -c ~/idning-source/c/nginx-1.0.11.read/
        tmux new-window  -t read:   -n bsd      -c ~/idning-source/4.4BSD-Lite/usr/src/sys
        tmux new-window  -t read:   -n ebook    -c ~/idning-source/ebook/
        tmux new-window  -t read:   -n leveldb  -c ~/idning-source/c/leveldb/
    ''')

def _start_or_attach(session, startcmd):
    if not _tmux_exists(session):
        cmd2(startcmd)
    cmd('tmux attach -t %s' % session)

@task
def ccl():
    _start_or_attach('ccl', '''
        tmux new -d      -s ccl  -n note -c ~/idning/blog_and_notes/
        tmux new-window  -t ccl: -n ccl  -c ~/idning-github/ccl
        tmux new-window  -t ccl: -n pcl  -c ~/idning-github/pcl
        tmux new-window  -t ccl: -n lang -c ~/idning/langtest/c
    ''')

@task
def slide():
    _start_or_attach('slide', '''
        tmux new -d      -s slide  -n src  -c ~/idning/slides/
        tmux new-window  -t slide: -n src  -c ~/idning/slides/
        tmux new-window  -t slide: -n src  -c ~/idning/slides/html
        ''')

@task
def twemproxy():
    _start_or_attach('twemproxy', '''
        tmux new -d      -s twemproxy  -n src  -c ~/idning-github/twemproxy/src/
        tmux new-window  -t twemproxy: -n src  -c ~/idning-github/twemproxy/src/
        tmux new-window  -t twemproxy: -n src  -c ~/idning-github/twemproxy/src

        tmux new-window  -t twemproxy: -n test -c ~/idning-github/test-twemproxy/
        tmux new-window  -t twemproxy: -n test -c ~/idning-github/test-twemproxy/
        tmux new-window  -t twemproxy: -n note -c ~/idning/blog_and_notes/

        mkdir -p /tmp/r/nutcracker-4100
        tmux new-window  -t twemproxy: -n 4100 -c /tmp/r/nutcracker-4100
    ''')

@task
def redissrc():
    session = sys._getframe().f_code.co_name
    _start_or_attach(session, TT('''
        tmux new -d      -s $session  -n src  -c ~/idning-github/redis/src/
        tmux new-window  -t $session: -n src  -c ~/idning-github/redis/src
        tmux new-window  -t $session: -n src  -c ~/idning-github/redis/src/
        tmux new-window  -t $session: -n note -c ~/idning/blog_and_notes/
    ''', locals()))

@task
def tmp():
    session = sys._getframe().f_code.co_name
    tmp = '~/test/tmp-%s' % common.format_time_to_hour()

    _start_or_attach(session, TT('''
        mkdir -p $tmp
        tmux new -d      -s $session -n note -c ~/idning/blog_and_notes/
        tmux new-window  -t $session: -n note -c ~/idning/blog_and_notes/
        tmux new-window  -t $session:  -c $tmp
        tmux new-window  -t $session:  -c $tmp
        tmux new-window  -t $session:  -c $tmp
        tmux new-window  -t $session:  -c $tmp
        tmux new-window  -t $session:  -c $tmp

    ''', locals()))

@task
def redismgr():
    session = sys._getframe().f_code.co_name
    _start_or_attach(session, TT('''
        tmux new -d        -s $session  -n src  -c ~/idning-github/redis-mgr/
        tmux new-window    -t $session: -n src  -c ~/idning-github/redis-mgr/
        tmux new-window    -t $session: -n src  -c ~/idning-github/redis-mgr/
        tmux new-window    -t $session: -n note -c ~/idning/blog_and_notes/
        tmux new-window    -t $session: -n note -c ~/idning/blog_and_notes/

        mkdir -p /tmp/r
        tmux new-window    -t $session: -n 4000  -c /tmp/r
        tmux new-window    -t $session: -n 4000  -c /tmp/r

        tmux send-keys     -t $session:0 "export REDIS_DEPLOY_CONFIG=conf && . ./bin/active" Enter
        tmux send-keys     -t $session:1 "export REDIS_DEPLOY_CONFIG=conf && . ./bin/active" Enter
        tmux send-keys     -t $session:2 "export REDIS_DEPLOY_CONFIG=conf && . ./bin/active" Enter
        tmux select-window -t $session:0
    ''', locals()))

@task
def leveldb():
    session = sys._getframe().f_code.co_name
    _start_or_attach(session, TT('''
        tmux new -d        -s $session  -n note -c ~/idning/blog_and_notes/
        tmux new-window    -t $session: -n src  -c ~/idning-github/leveldb/
        tmux new-window    -t $session: -n src  -c ~/idning-github/leveldb/
    ''', locals()))

@task
def ssdb():
    session = sys._getframe().f_code.co_name
    _start_or_attach(session, TT('''
        tmux new -d        -s $session  -n note -c ~/idning/blog_and_notes/
        tmux new-window    -t $session: -n src  -c ~/idning-github/ssdb/src/
        tmux new-window    -t $session: -n src  -c ~/idning-github/ssdb/src/
    ''', locals()))

@task
def lua():
    session = sys._getframe().f_code.co_name
    _start_or_attach(session, TT('''
        tmux new -d        -s $session  -n note -c ~/idning/blog_and_notes/
        tmux new-window    -t $session: -n 1.1  -c ~/idning-source/c/lua/lua-1.1
        tmux new-window    -t $session: -n 5.1  -c ~/idning-source/c/lua/lua-5.1
        tmux new-window    -t $session: -n langtest  -c ~/idning/langtest/lua/c-lua
    ''', locals()))

@task
def lt():
    session = sys._getframe().f_code.co_name
    _start_or_attach(session, TT('''
        tmux new -d        -s $session  -n src  -c /home/ning/idning/langtest/leet
        tmux new-window    -t $session: -n src  -c /home/ning/idning/langtest/leet
        tmux new-window    -t $session: -n src  -c /home/ning/idning/langtest/leet
    ''', locals()))

@task
def nginx():
    _start_or_attach('nginx', '''
        tmux new -d      -s nginx   -n src     -c       ~/idning-source/c/nginx-1.0.11.read/src
        tmux new-window  -t nginx:  -n src     -c       ~/idning-source/c/nginx-1.0.11.read/src
        tmux new-window  -t nginx:  -n note    -c       ~/idning/blog_and_notes/
        tmux new-window  -t nginx:  -n note    -c       ~/idning/blog_and_notes/
        tmux new-window  -t nginx:  -n nmodule -c       ~/idning/langtest/nginx/ning-module
    ''')

@task
def note():

    _start_or_attach('note', '''
        tmux new -d      -s note  -n note       -c /home/ning/idning/blog_and_notes/
        tmux new-window  -t note: -n note       -c /home/ning/idning/blog_and_notes/
    ''')

@task
def kafka():
    session = sys._getframe().f_code.co_name
    _start_or_attach(session, TT('''
        tmux new -d        -s $session  -n src  -c /home/ning/idning/blog_and_notes/
        tmux new-window    -t $session: -n src  -c ~/test/kafka/kafka-0.8.0-src/core/src/main/scala/kafka
        tmux new-window    -t $session: -n src  -c ~/test/kafka/kafka-0.8.0-src/core/src/main/scala/kafka
        tmux new-window    -t $session: -n src  -c ~/test/kafka/kafka-0.8.0-src/core/src/main/scala/kafka
    ''', locals()))



@task
def edit():
    cmd('''
gnome-terminal --geometry=120x40
--tab --working-directory ~/idning/blog_and_notes/ -e '/home/ning/local/bin/vim /home/ning/.bin/workspace.py'
''')

@task
def da():
    cmd('''
gnome-terminal --geometry=120x40
--tab --working-directory ~/idning-github/ning-diary/ -e '/home/ning/local/bin/vim 2014/201405.rst'
''')






@task
def startpythonprj():
    cmd('mkdir bin')
    cmd('mkdir lib')
    cmd('mkdir log')
    cmd('mkdir doc')
    cmd('mkdir conf')
    cmd('touch README.rst')

    #cmd('mkdir src')

@task
def review(fname):
    print fname
    cmd('mkdir -p /tmp/indent/')
    tmp = '/tmp/indent/%s' % fname.replace('/', '_')
    '''-T xx可以保证:
    1. struct msg *msg 而不是 struct msg * msg
    2. (uint32_t)n 而不是 (uint32_t) n  (-ncs的功能)

    '''
    c = 'indent -linux -i4 -ci4 -ts4 --no-tabs -psl -ncs -T uint64_t -T uint32_t -T uint16_t -T uint8_t -T size_t -T off_t %(fname)s -o %(tmp)s  && meld %(fname)s %(tmp)s' % locals()
    cmd(c)

def getfun():
    import types
    tasks = [k for k, v in globals().items() if type(v) is types.FunctionType and hasattr(v, 'attr')]
    return tasks

def main():
    tasks = getfun()

    parser = argparse.ArgumentParser(formatter_class=RawTextHelpFormatter)
    parser.add_argument('task', choices=tasks, metavar='task', help='\n'.join(tasks))
    parser.add_argument('xargs', nargs='*', help='xargs')

    args = common.parse_args2(None, parser)

    selected = [n for n in tasks if n.startswith(args.task)]
    if len(selected) == 0:
        return
    if len(selected) != 1:
        for i in selected:
            print i

    if len(selected) == 1:
        print '[execute]', selected[0]
        eval(selected[0] + '(*args.xargs)')

if __name__ == "__main__":
    main()
