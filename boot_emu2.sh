#!/bin/bash
export ANDROID_SDK_ROOT=/root/.buildozer/android/platform/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export ANDROID_AVD_HOME=/root/.android/avd
EMU="$ANDROID_SDK_ROOT/emulator/emulator"
ADB="$ANDROID_SDK_ROOT/platform-tools/adb"

# clean slate
pkill -9 -f "qemu-system" 2>/dev/null || true
pkill -9 -f "emulator -avd" 2>/dev/null || true
"$ADB" kill-server 2>/dev/null || true
sleep 2

# start adb server FIRST so emulator can register
"$ADB" start-server
sleep 1

echo "=== Launching emulator fully detached (gpu off) ==="
setsid "$EMU" -avd clocktest -no-window -no-audio -no-boot-anim \
    -gpu off -no-snapshot -no-snapshot-save -no-snapshot-load \
    -memory 2048 -wipe-data \
    > /tmp/emulator.log 2>&1 < /dev/null &
disown
echo "LAUNCHED pid=$!"
sleep 10
echo "=== qemu running? ==="
pgrep -af qemu-system | head -2 || echo NO-QEMU
echo "=== adb devices ==="
"$ADB" devices
