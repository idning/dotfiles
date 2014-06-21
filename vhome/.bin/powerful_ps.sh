查看当前用户程序实际内存占用，并排序
ps -u $USER -o pid,rss,cmd --sort -rss
统计程序的内存耗用
ps -eo fname,rss|awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}'|sort -k2 -nr
按内存从大到小排列进程
ps -eo "%C  : %p : %z : %a"|sort -k5 -nr
按cpu利用率从大到小排列进程
ps -eo "%C  : %p : %z : %a"|sort  -nr

