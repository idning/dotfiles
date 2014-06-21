#!/bin/bash
# author : ning 
# reference: http://blog.lathi.net/articles/2008/09/13/scripting-screen
#Scripting Screen
#Posted by Doug on Saturday, September 13, 2008

#I do pretty much all my work using GNU Screen inside a terminal. I use a different screen session for each project and have pretty much the same window configuration for each session. After finally getting tired of manually setting up my screen sessions, here’s how I managed to script new session setup.

while getopts 'S:' OPT; do
    case $OPT in
        S)
            PROJECT="$OPTARG";;
        ?)
            echo "Usage: `basename $0` -S screenname"
            exit
    esac
done

if [ "$PROJECT" == "" ]; then
    echo "Usage: `basename $0` -S screenname"
    exit;
else
    echo "screen : $PROJECT"
fi


#DEVEL_DIR=$2
#PROJECT=$1
#echo $DEVEL_DIR

screen -d -m -S $PROJECT

screen -X -S $PROJECT -p 0 title run
screen -X -S $PROJECT -p 0 stuff "ls
"
screen -X -S $PROJECT screen -t test 1
#screen -X -S $PROJECT -p 1 stuff "cd $DEVEL_DIR/$PROJECT; autotest
#"
screen -X -S $PROJECT screen -t server 2
#PORT=`port_number`
#screen -X -S $PROJECT -p 2 stuff "cd $DEVEL_DIR/$PROJECT; ./script/server -p $PORT
#"
screen -X -S $PROJECT screen -t bash1 3
#screen -X -S $PROJECT -p 3 stuff "cd $DEVEL_DIR/$PROJECT; ./script/console
#"
screen -X -S $PROJECT screen -t bash2 4
#screen -X -S $PROJECT -p 4 stuff "cd $DEVEL_DIR/$PROJECT
#"

screen -r $PROJECT


#PS3="Which screen session to restore? "
#select PROJECT in `screen_list` New; do
    #if [ $PROJECT == "New" ]; then
        #PS3="Which project to start a session for? "
        #select PROJECT in `ls -F $DEVEL_DIR | egrep /$ | sed 's/\///' `; do
        #PS3=$OLD_PS3
        #screens=`screen_list | grep $PROJECT`
        #if [ "x$screens" == "x" ]; then

            #screen -d -m $SCREEN_OPTS -S $PROJECT

            #screen -X -S $PROJECT -p 0 title emacs 
            #screen -X -S $PROJECT -p 0 stuff "emacs $DEVEL_DIR/$PROJECT
#"
            #screen -X -S $PROJECT screen -t test 1
            #screen -X -S $PROJECT -p 1 stuff "cd $DEVEL_DIR/$PROJECT; autotest
#"
            #screen -X -S $PROJECT screen -t server 2
            #PORT=`port_number`
            #screen -X -S $PROJECT -p 2 stuff "cd $DEVEL_DIR/$PROJECT; ./script/server -p $PORT
#"
            #screen -X -S $PROJECT screen -t console 3
            #screen -X -S $PROJECT -p 3 stuff "cd $DEVEL_DIR/$PROJECT; ./script/console
#"
            #screen -X -S $PROJECT screen -t bash 4
            #screen -X -S $PROJECT -p 4 stuff "cd $DEVEL_DIR/$PROJECT
#"

            #for i in 0 1 2 3
            #do
                ## do this to force screen to refresh the hard status line
                #screen -X -S $PROJECT select $i
            #done
        #fi
        #PS3="Which project to start a session for? "
        #done
    #fi
    #PS3="Which screen session to restore? "
#done
#PS3=$OLD_PS3
