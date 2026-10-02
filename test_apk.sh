#!/bin/bash
export ANDROID_SDK_ROOT=/root/.buildozer/android/platform/android-sdk
ADB=$ANDROID_SDK_ROOT/platform-tools/adb
APK=$(ls -t /root/clock_app/bin/*.apk | head -1)
echo "=== APK: $APK ==="

# find package + main activity
PKG=$(grep -E '^package.name' /root/clock_app/buildozer.spec | head -1 | sed 's/.*=//' | tr -d ' \r')
DOM=$(grep -E '^package.domain' /root/clock_app/buildozer.spec | head -1 | sed 's/.*=//' | tr -d ' \r')
FULLPKG="$DOM.$PKG"
echo "=== package: $FULLPKG ==="

echo "=== uninstall old (ignore errors) ==="
"$ADB" uninstall "$FULLPKG" 2>/dev/null || true

echo "=== install ==="
"$ADB" install -r "$APK"

echo "=== clear logcat ==="
"$ADB" logcat -c

echo "=== launch main activity ==="
"$ADB" shell monkey -p "$FULLPKG" -c android.intent.category.LAUNCHER 1

echo "=== wait 12s for crash ==="
sleep 12

echo "=== is process alive? ==="
"$ADB" shell pidof "$FULLPKG" && echo "PROCESS-ALIVE" || echo "PROCESS-DEAD"

echo "=== python / crash logcat ==="
"$ADB" logcat -d -v brief | grep -iE "python|AndroidRuntime|kivy|Traceback|Error|FATAL|SDL|$FULLPKG" | tail -120
