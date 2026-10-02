#!/bin/bash
SRC=/root/clock_app/.buildozer/android/platform/build-arm64-v8a_armeabi-v7a_x86_64/build/other_builds/ffmpeg-sdl2/arm64-v8a__ndk_target_21/ffmpeg
echo "=== fft-related headers in source libavcodec ==="
ls "$SRC/libavcodec/" | grep -iE "fft|dct|rdft" || echo "none"
echo "=== RELEASE / version ==="
cat "$SRC/RELEASE" 2>/dev/null
grep -E "VERSION_MAJOR|VERSION_MINOR" "$SRC/libavcodec/version.h" 2>/dev/null | head
echo "=== does source have avfft.h anywhere ==="
find "$SRC" -name avfft.h 2>/dev/null || echo "NONE-anywhere"
echo "=== total header count in installed include/libavcodec ==="
ls "$SRC/include/libavcodec/" | wc -l
