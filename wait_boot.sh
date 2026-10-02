#!/bin/bash
export ANDROID_SDK_ROOT=/root/.buildozer/android/platform/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
ADB="$ANDROID_SDK_ROOT/platform-tools/adb"

"$ADB" start-server >/dev/null 2>&1
echo "=== waiting for device ==="
"$ADB" wait-for-device
echo "=== device online, polling boot_completed ==="
for i in $(seq 1 60); do
    B=$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')
    echo "poll $i: boot_completed='$B'"
    if [ "$B" = "1" ]; then
        echo "BOOT-COMPLETE"
        break
    fi
    sleep 5
done
echo "=== devices ==="
"$ADB" devices
