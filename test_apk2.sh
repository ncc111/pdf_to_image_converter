#!/bin/bash
export ANDROID_SDK_ROOT=/root/.buildozer/android/platform/android-sdk
ADB=$ANDROID_SDK_ROOT/platform-tools/adb
EMU=$ANDROID_SDK_ROOT/emulator/emulator
PKG=org.ivanng.clock
APK=$(ls -t /root/clock_app/bin/*x86_64*.apk | head -1)

echo "=== devices ==="
"$ADB" devices
# If no device, boot the emulator
if ! "$ADB" devices | grep -q "emulator-5554"; then
  echo "=== emulator not running, launching ==="
  pkill -9 -f qemu-system 2>/dev/null || true
  "$ADB" start-server
  setsid "$EMU" -avd clocktest -no-window -no-audio -no-boot-anim \
     -gpu off -no-snapshot -memory 2048 > /tmp/emulator.log 2>&1 < /dev/null &
  disown
  "$ADB" wait-for-device
  for i in $(seq 1 60); do
    B=$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')
    [ "$B" = "1" ] && break
    sleep 5
  done
fi

echo "=== APK: $APK ==="
"$ADB" uninstall "$PKG" 2>/dev/null || true
"$ADB" install -r "$APK"
"$ADB" logcat -c
"$ADB" shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
echo "=== wait 15s ==="
sleep 15
echo "=== alive? ==="
"$ADB" shell pidof "$PKG" && echo PROCESS-ALIVE || echo PROCESS-DEAD
echo "=== crash log (if any) ==="
"$ADB" shell run-as "$PKG" cat files/clock_crash.log 2>/dev/null || echo "no crash log"
echo "=== video provider + errors ==="
"$ADB" logcat -d -v brief | grep -iE "VideoBase|ffpyplayer|Unknown <|Error loading|provider|shutil|Permission denied|Traceback|CLOCK_APP_STARTUP" | tail -40
echo "=== screenshot ==="
"$ADB" shell screencap -p /sdcard/shot2.png
"$ADB" pull /sdcard/shot2.png /root/clock_app/shot2.png >/dev/null 2>&1 && cp /root/clock_app/shot2.png /mnt/c/Users/IvanNG/clock_app/shot2.png && echo "shot2.png ready"
