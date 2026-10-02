#!/bin/bash
echo "=== KVM ==="
ls -la /dev/kvm 2>&1
echo "=== CPU-VIRT-COUNT ==="
grep -c -E 'vmx|svm' /proc/cpuinfo
echo "=== ANDROID SDK ==="
export ANDROID_SDK_ROOT=/root/.buildozer/android/platform/android-sdk
ls "$ANDROID_SDK_ROOT/system-images" 2>/dev/null || echo NO-SYSTEM-IMAGES
ls "$ANDROID_SDK_ROOT/emulator" 2>/dev/null || echo NO-EMULATOR-DIR
echo "=== cmdline-tools ==="
ls "$ANDROID_SDK_ROOT/cmdline-tools/" 2>/dev/null
find "$ANDROID_SDK_ROOT" -name sdkmanager 2>/dev/null
find "$ANDROID_SDK_ROOT" -name avdmanager 2>/dev/null
echo "=== free disk ==="
df -h /root | tail -1
