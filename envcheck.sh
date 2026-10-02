#!/bin/bash
export ANDROID_SDK_ROOT=/root/.buildozer/android/platform/android-sdk
ADB=$ANDROID_SDK_ROOT/platform-tools/adb
echo "=== ANDROID_* env seen by python (from logcat) ==="
"$ADB" logcat -d | grep -iE "ANDROID_PRIVATE|ANDROID_APP_PATH|ANDROID_ARGUMENT|Changing directory" | tail -10
