#!/bin/bash
B=/root/clock_app/.buildozer/android/platform/build-arm64-v8a_armeabi-v7a_x86_64
rm -rf "$B/build/other_builds/ffmpeg-"* "$B/build/other_builds/ffpyplayer"* "$B/packages/ffmpeg" "$B/packages/ffpyplayer"
echo "cleaned"
ls "$B/build/other_builds/" | grep -iE "ffmpeg|ffpy" || echo "none-remain"
