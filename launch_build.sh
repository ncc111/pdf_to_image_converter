#!/bin/bash
cd /root/clock_app
: > /root/clock_app/rebuild.log
nohup setsid bash /root/clock_app/rebuild.sh >> /root/clock_app/rebuild.log 2>&1 < /dev/null &
CHILD=$!
sleep 1
echo "LAUNCHED child=$CHILD"
ps -o pid,cmd -p "$CHILD" 2>/dev/null || echo "child re-forked via setsid"
