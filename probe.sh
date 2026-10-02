#!/bin/bash
export ANDROID_SDK_ROOT=/root/.buildozer/android/platform/android-sdk
ADB=$ANDROID_SDK_ROOT/platform-tools/adb
PKG=org.ivanng.clock
echo "=== writability of candidate dirs (as the app user) ==="
"$ADB" shell run-as "$PKG" sh -c '
for d in "$PWD" /data/data/'"$PKG"'/files /data/data/'"$PKG"'/files/app /data/data/'"$PKG"'/cache; do
  if touch "$d/.probe" 2>/dev/null; then echo "WRITABLE: $d"; rm -f "$d/.probe"; else echo "RO:       $d"; fi
done
echo "cwd=$PWD"
'
