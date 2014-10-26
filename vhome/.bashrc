# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus



alias ll='ls -l -h -i -t'
alias sshr='ssh -l root'
alias svn_edit_ignore='svn propedit svn:ignore .'
alias svn_add_unknown='svn st | grep "? " | sed "s/? *//" | xargs svn add'
alias vi='vim'
alias rrc='. ~/.bashrc'
alias dia='dia --integrated'

alias n='/home/ning/.bin/vps_monitor_no_svn.py -v'

#this is for my c code in /idning/langtest/c , which make it easy to make &edit
export prj=  
alias s='scons'
alias m='make'
alias mm='make -f Makefile.me.mk'
alias f='vi $prj.c'
alias i='~/.bin/info.sh'
alias gbk2utf8='enca -L zh_CN -x utf-8 '
alias utf82gbk='enca -L zh_CN -x gbk '
# gbk2utf8 sometimes not work
alias gbk2utf8name='convmv -r -f gbk -t utf8 *'
#alias dos2unix='sed -i "s/\r//" '

alias unix_center='ssh idning@ubuntu.unix-center.net'
alias gicp='ping idning.gicp.net'
#alias yum='sudo aptitude'
alias konsole_run='konsole --profile run'

alias screenshot-win='gnome-screenshot -wbi --sync'

alias clear='echo -e "\n\n\n\n\n\n\n---------------------------------------------------\n\n\n\n\n\n\n"'
#alias ec2='ssh -i /home/ning/workspace/amazon-ec2/ning_ec2.pem ec2-user@ec2-175-41-164-55.ap-southeast-1.compute.amazonaws.com'
alias ec2='ssh -i /home/ning/ec2_20100401.pem ec2-user@ec2-50-16-96-178.compute-1.amazonaws.com'
alias ec2proxy='ssh -Nf -D 9527 -i /home/ning/ec2_20100401.pem ec2-user@ec2-50-16-96-178.compute-1.amazonaws.com'


alias line_count='find . -name "*.cc" -or -name "*.c" -or -name "*.h" -or -name "*.cpp" | xargs cat | wc -l'
alias du1='du -h --max-depth=1'
alias mysql='mysql --default-character-set=utf8'
alias grep='grep --color=auto'
alias ack='ack --type-set TYPE=.rst,.md '

export AUTOSSH_DEBUG=DEBUG
export AUTOSSH_LOGFILE=/tmp/autohssh.log

alias vps='ssh root@64.120.233.12'
alias vpsproxy='autossh -Nf -D 0.0.0.0:9527 root@64.120.233.12'
alias vpsproxy2='autossh -Nf  -L *:9527:*:9527 root@64.120.233.12'

alias vpstest='watch curl -v --socks5 127.0.0.1:9527 http://www.xiaonei.com/'
alias vps9527='sudo netstat -antp | grep 9527'

alias vpskill='kill -9 $( lsof -i:9527  -sTCP:LISTEN -t )'
alias noporxy='export http_proxy=;export https_proxy=;export all_proxy=;export HTTP_PROXY=;export HTTPS_PROXY=;export ALL_PROXY=;'
#sniffer
alias tcpflow='tcpflow -c'
alias http_tshark='sudo tshark -i wlan0 "tcp port 80" '
alias http_wireshark='sudo wireshark  -iwlan0 -k -w /tmp/wireshark.log -f "tcp port 80" -R "http and tcp.len>0"'   #please use filter http and tcp.len>0
alias http_tcpflow='sudo tcpflow -iwlan0 -b 200 -c "host 74.125.71.138 or host www.google.com" | tee /tmp/tcpflow.log'
#alias http_justniffer='sudo justniffer -iwlan0 -rx'
alias http_justniffer='sudo justniffer -p "host www.google.com" -iwlan0 -l "----------------------------------------------------------------%newline%request%newline%response"'
alias http_urlsnarf='sudo urlsnarf -i wlan0'
alias tcpdump='tcpdump -p -i wan0' #非混杂模式.
alias ctags='ctags --sort=no' #不排序, 参看./notes/misc/vim-ctags-vs-cscope.rst

alias ci="svn st | egrep '[MA] *' | sed 's/[MA] *//' | grep -v Makefile | awk '{printf(\"%s \",$0)}' | xargs svn ci "
alias svn_gui_diff="svn diff --diff-cmd svn_diff_tool.sh"


alias emac='emacs -nw'
alias et='emacsclient -t "$@" -a ""'
alias ee='emacsclient -nc "$@" -a ""'

alias date2timestamp='date  +'%s' -d '
alias timestamp2date='date  +"%F %T" -d '
alias readlink='readlink -f'
alias ack2='ack --type-add dia=.dia --type-add svg=.svg --type=nodia --type=nosvg '
alias ack2='ack --type-add rst=.rst --type-add md=.md --type=rst --type=md'

alias nosetests='nosetests --nocapture  --nologcapture'
alias gitg='gitg --all'

#alias restartnetworking='sudo modprobe -r iwlagn  && modprobe -r iwlcore && modprobe -r cfg80211 && modprobe -r mac80211  && sudo modprobe  iwlagn  && modprobe  iwlcore && modprobe  mac8021 cfg80211'


#lsof -i:9527 -sTCP:LISTEN -t


#if [ "`pwd`" = "/home/ning/idning/langtest/cpp" ]; then
#    alias f='vi $prj.cpp'
#fi

export EDITOR=vim
if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi


export PATH=~/soft/android-ndk-r7/:~/soft/processing-2.0b8/:~/local/bin/:~/bin:~/.bin:~/soft/mongodb-linux-x86_64-static-legacy-2.0.6:~/soft/Sublime_Text_2:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/lib:~/local/lib/

#man 如何显示彩色字符
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


t(){
    if [ $# -eq 0 ]
      then
        tmux ls
      else
        if tmux has-session -t $@; then tmux attach -t $@; else tmux new -s $@; fi
    fi

}

#PS1="\[\e[36;1m\]\u@\[\e[32;1m\]\H \[\033[36;31m\]\w\[\033[37;36m\]\$ \[\e[0m\]"
#
#PS1="\[\e[32;35m\]\u@\[\e[32;1m\]\H \[\033[36;31m\]\w\[\033[37;36m\]\$ \[\e[0m\]"
#PS1="\[\e[01;31m\]\u@\[\e[01;32m\]\H \[\033[36;31m\]\w\[\033[37;36m\]\$ \[\e[0m\]"
#PS1="\[\e[01;31m\]\u@\[\e[01;33m\]\H \[\033[36;31m\]\w\[\033[37;36m\]\$ \[\e[0m\]" 


make_ps(){
    ip=$(/sbin/ifconfig wlan0 |grep inet |cut -d : -f 2 | cut -d ' ' -f 1|sed -e '/^$/d')
    host=$(hostname)
    if [[ $host == "localhost" ]]
    then
        PS1="\[\e[36;1m\]\u@\[\e[32;1m\]$ip: \[\033[36;31m\]\w\[\033[37;36m\]\$ \[\e[0m\]"
    else
        PS1="\[\e[36;1m\]\u@\[\e[32;1m\]\H \[\033[36;31m\]\w\[\033[37;36m\]\$ \[\e[0m\]"
    fi
}

make_ps

#设置history的时间格式.
export HISTTIMEFORMAT='%F %T '
HISTSIZE=200000
#每次将history计入文件.
datestamp_for_history(){
    export bash_id=$(echo $PPID)
    export username=$(whoami)
    export workdir=$(echo $PWD)
    export infohis=`history 1`
    echo $username $bash_id $workdir $infohis >> $HOME/.history-timestamp
    echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"
} 
#
export PROMPT_COMMAND=datestamp_for_history

#export VIRTUAL_ENV_DISABLE_PROMPT='xx'
#export PYTEST_BRIGHT_COLOR='xx'
#source ~/ENV/bin/activate


ulimit -c unlimited
#ulimit -n 65535

export GHSYNC_DIR='/home/ning/idning-github2/'

export GDBHISTFILE='~/.gdb_history'

lsrecent(){
    find $1 -name '*.rst' -printf '%T@ %p\n' | grep -v '.svn' | sort -nr | awk '{print strftime("%F %R", $1), $2}' > .recent && vim .recent
    #find $1 -printf '%T@ %p\n' | grep -v '.svn' |grep -v '\.git' | sort -nr | awk '{print strftime("%F %R", $1), $2}' > .recent && vim .recent
    #find . -name '*.rst' 
}

#pythonbrew install python2.7
[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"

# this will enable 256 color in vim, which is need by vim-airline, but it's unhappy
#if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    #export TERM='xterm-256color'
#else
    #export TERM='xterm-color'
#fi

unset TMUX
eval "$(register-python-argcomplete workspace.py)"


unzip-ning(){
    LANG=C 7z x $@ && convmv -f cp936 -t utf8 -r --notest -- *
}
