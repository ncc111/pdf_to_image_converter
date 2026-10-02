#!/bin/bash
set -e
export ANDROID_SDK_ROOT=/root/.buildozer/android/platform/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export ANDROID_AVD_HOME=/root/.android/avd
SDKM="$ANDROID_SDK_ROOT/tools/bin/sdkmanager"
# Java is provided by buildozer's checks; ensure JAVA_HOME if present
which java && java -version 2>&1 | head -1

echo "=== Accepting licenses ==="
yes | "$SDKM" --sdk_root="$ANDROID_SDK_ROOT" --licenses >/dev/null 2>&1 || true

echo "=== Installing emulator, platform-tools, system image (API 33 x86_64) ==="
yes | "$SDKM" --sdk_root="$ANDROID_SDK_ROOT" \
    "emulator" \
    "platform-tools" \
    "system-images;android-33;google_apis;x86_64"

echo "=== Done installing. Listing ==="
ls "$ANDROID_SDK_ROOT/emulator/emulator" && echo EMULATOR-OK
ls "$ANDROID_SDK_ROOT/system-images/android-33/google_apis/x86_64" && echo IMAGE-OK
