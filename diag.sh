#!/bin/bash
export ANDROID_SDK_ROOT=/root/.buildozer/android/platform/android-sdk
ADB=$ANDROID_SDK_ROOT/platform-tools/adb
PKG=org.ivanng.clock

echo "=== still alive? ==="
"$ADB" shell pidof "$PKG" && echo ALIVE || echo DEAD

echo "=== any crash log written? ==="
"$ADB" shell run-as "$PKG" cat files/clock_crash.log 2>/dev/null || echo "no crash log (app did not hit except handler)"

echo "=== full python-tag traceback search ==="
"$ADB" logcat -d -v brief | grep -iE "Traceback|CLOCK_APP_STARTUP_CRASH|Exception|  File \"|Error:" | tail -60

echo "=== screenshot ==="
"$ADB" shell screencap -p /sdcard/shot.png
"$ADB" pull /sdcard/shot.png /root/clock_app/shot.png >/dev/null 2>&1 && echo "pulled shot.png" || echo "no screenshot"
ls -la /root/clock_app/shot.png 2>/dev/null
