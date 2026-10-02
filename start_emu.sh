#!/bin/bash
export ANDROID_SDK_ROOT=/root/.buildozer/android/platform/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export ANDROID_AVD_HOME=/root/.android/avd
AVDM="$ANDROID_SDK_ROOT/tools/bin/avdmanager"
EMU="$ANDROID_SDK_ROOT/emulator/emulator"
ADB="$ANDROID_SDK_ROOT/platform-tools/adb"

echo "=== Creating AVD 'clocktest' ==="
echo "no" | "$AVDM" create avd -n clocktest \
    -k "system-images;android-33;google_apis;x86_64" \
    --force

echo "=== AVD list ==="
"$AVDM" list avd | grep -E "Name|Path" || true

echo "=== Starting emulator headless (background) ==="
nohup "$EMU" -avd clocktest -no-window -no-audio -no-boot-anim \
    -gpu swiftshader_indirect -no-snapshot -accel on \
    > /tmp/emulator.log 2>&1 &
echo "EMULATOR-PID=$!"
sleep 3
echo "=== emulator.log head ==="
head -20 /tmp/emulator.log
