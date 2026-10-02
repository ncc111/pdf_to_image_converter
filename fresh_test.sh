#!/bin/bash
export ANDROID_SDK_ROOT=/root/.buildozer/android/platform/android-sdk
ADB=$ANDROID_SDK_ROOT/platform-tools/adb
PKG=org.ivanng.clock
APK=$(ls -t /root/clock_app/bin/*x86_64*.apk | head -1)

echo "=== FRESH uninstall ==="
"$ADB" uninstall "$PKG" 2>/dev/null || true
echo "=== install ==="
"$ADB" install "$APK"
"$ADB" logcat -c
"$ADB" shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
echo "=== wait 14s ==="
sleep 14
echo "=== ALIVE? ==="
"$ADB" shell pidof "$PKG" && echo ALIVE || echo DEAD
echo "=== relevant log lines ==="
"$ADB" logcat -d | grep -iE "shutil.Error|Permission denied|Provider: ffpyplayer|VideoFFPy|Start application main loop|KIVY_APP" | tail -12
echo "=== screenshot ==="
"$ADB" shell screencap -p /sdcard/shot3.png
"$ADB" pull /sdcard/shot3.png /root/clock_app/shot3.png >/dev/null 2>&1 && cp /root/clock_app/shot3.png /mnt/c/Users/IvanNG/clock_app/shot3.png && echo "shot3.png ready"
