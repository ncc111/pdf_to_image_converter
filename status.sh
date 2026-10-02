#!/bin/bash
ADB=/root/.buildozer/android/platform/android-sdk/platform-tools/adb
echo "=== devices ==="
"$ADB" devices
echo "=== qemu procs ==="
pgrep -af qemu | head -5 || echo NONE
echo "=== last 40 emu log ==="
tail -40 /tmp/emulator.log
