#!/bin/bash
LOG=/root/clock_app/build_ffpy3.log
echo "=== local-recipes flag used? ==="
grep -m2 -iE "local.recipes" "$LOG"
echo "=== ffmpeg download source ==="
grep -m2 -iE "Downloading ffmpeg from" "$LOG"
echo "=== n4.3.1 mentioned? ==="
grep -m2 "n4.3.1" "$LOG"
echo "=== APK files ==="
ls -la /root/clock_app/bin/*.apk
