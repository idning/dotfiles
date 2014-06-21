#从网上找到，现在被autossh代替，很有用的代码哟，学习bash不错, 哈哈，函数.
function make_proxy() {
    PROXY_ID=$(pgrep -f "ssh -D port user@host")

    if [[ $PROXY_ID != 0 ]];then
        ssh -D port user@host ;
    fi
}

function test_proxy() {
    curl -s -I --socks5 localhost:9527 http://www.yahoo.com/ > /dev/null;
}

SHORT=5
LONG=5
count=0

while true; do
    test_proxy;
    if [[ $? != 0 ]];then
        #make_proxy;
        echo 'proxy err'
        duration=$SHORT;
        ((count++));
    else
        count=0;
        duration=$LONG;
    fi
    if [[ $count == 5 ]];then
        notify-send -t 1000 -u critical "Proxy Failed" "Couldn't connect to proxy";
        count=0;
    fi
    sleep $duration;
done
