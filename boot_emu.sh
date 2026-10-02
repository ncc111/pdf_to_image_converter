#!/bin/bash
export ANDROID_SDK_ROOT=/root/.buildozer/android/platform/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export ANDROID_AVD_HOME=/root/.android/avd
EMU="$ANDROID_SDK_ROOT/emulator/emulator"
ADB="$ANDROID_SDK_ROOT/platform-tools/adb"

pkill -f "emulator -avd clocktest" 2>/dev/null || true
"$ADB" kill-server 2>/dev/null || true
sleep 2

echo "=== Starting emulator headless (background) ==="
nohup "$EMU" -avd clocktest -no-window -no-audio -no-boot-anim \
    -gpu swiftshader_indirect -no-snapshot -accel on -memory 2048 \
    > /tmp/emulator.log 2>&1 &
echo "EMULATOR-PID=$!"
sleep 5
echo "=== emulator.log head ==="
head -25 /tmp/emulator.log
