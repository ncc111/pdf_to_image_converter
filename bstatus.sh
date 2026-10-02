#!/bin/bash
echo "LOG_TAIL:"
tail -n 25 /root/clock_app/rebuild.log 2>/dev/null
echo "PROCS:"
pgrep -af buildozer | grep -v pgrep | head -3
echo "END"
