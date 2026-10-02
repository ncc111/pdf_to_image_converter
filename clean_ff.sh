#!/bin/bash
B=/root/clock_app/.buildozer/android/platform/build-arm64-v8a_armeabi-v7a_x86_64
echo "=== removing cached ffmpeg + ffpyplayer build dirs (all archs) ==="
rm -rf "$B/build/other_builds/ffmpeg-"*
rm -rf "$B/build/other_builds/ffpyplayer"*
rm -rf "$B/packages/ffmpeg"
rm -rf "$B/packages/ffpyplayer"
echo "=== removing cached ffmpeg downloads so n4.3.1 is fetched fresh ==="
find /root/.buildozer /root/clock_app/.buildozer -iname "*ffmpeg*8.0*" -maxdepth 6 2>/dev/null
find "$B/packages" -maxdepth 2 -iname "*ffmpeg*" 2>/dev/null
echo "=== verify local recipe version ==="
grep -n "version =" /root/clock_app/recipes/ffmpeg/__init__.py | head -1
echo "=== done cleaning ==="
ls "$B/build/other_builds/" | grep -iE "ffmpeg|ffpy" || echo "no ffmpeg/ffpy build dirs remain"
