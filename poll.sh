#!/bin/bash
echo "=== buildozer running? ==="
if pgrep -af buildozer >/dev/null; then echo YES-RUNNING; else echo NOT-RUNNING; fi
echo "=== progress markers (last 25) ==="
grep -E "Building|Cythonizing|Install python|arch|APK|BUILD|Compiling|packaging|available in the bin" /root/clock_app/build_x86.log 2>/dev/null | tail -25
echo "=== raw tail 5 ==="
tail -5 /root/clock_app/build_x86.log 2>/dev/null
