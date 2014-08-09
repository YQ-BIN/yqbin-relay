#!/bin/sh

prog=yq-bin_checker
RETVAL=0

start(){
    [ -x ~/yqbin/"$prog".pl ] || exit 1
    ~/yqbin/"$prog".pl > /dev/null 2>&2
    RETVAL=$?
    echo -n $"Starting $prog: "
    [ $RETVAL -eq 0 ] && echo "success" || echo "failure"
    [ $RETVAL -eq 0 ] && touch /tmp/$prog
    echo
}

stop(){
    if [ -f /var/run/"$prog".pid ] ; then
        kill `cat /var/run/"$prog".pid`
        RETVAL=$?
    else
        RETVAL=1
    fi

    echo -n $"Stopping $prog: "
    [ $RETVAL -eq 0 ] && echo "success" || echo "failure"
    [ $RETVAL -eq 0 ] && rm /tmp/$prog
    [ $RETVAL -eq 0 ] && rm /var/run/"$prog".pid
    echo
}

stats(){
    [ -f /var/run/"$prog".pid ] && echo "$prog PID:`cat /var/run/"$prog".pid`"
}

case $1 in
        start ) start ;;
        stop ) stop ;;
        restart ) stop start ;;
        stats ) stats ;;
        * ) echo "$0 {start|stop|restart|stats}" ;;
esac
