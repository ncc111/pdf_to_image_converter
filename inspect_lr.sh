#!/bin/bash
LOG=/root/clock_app/build_ffpy2.log
echo "=== local recipes mentioned? ==="
grep -niE "local_recipes|local-recipes|recipes/ffmpeg|recipes dir" "$LOG" | head -10
echo "=== ffmpeg recipe/version/download lines ==="
grep -niE "ffmpeg" "$LOG" | grep -iE "download|version|recipe|Building compiled|n4.3.1|8.0.1|Downloading" | head -12
echo "=== p4a toolchain command line ==="
grep -niE "pythonforandroid.toolchain create" "$LOG" | head -2
