#!/bin/bash
R=/root/clock_app/.buildozer/android/platform/python-for-android/pythonforandroid/recipes
echo "=== ffmpeg recipe ==="
grep -nE 'version|url|depends' "$R/ffmpeg/__init__.py"
echo "=== ffpyplayer recipe ==="
grep -nE 'version|url|depends|patches' "$R/ffpyplayer/__init__.py"
echo "=== ffpyplayer_codecs recipe head ==="
grep -nE 'version|url|depends' "$R/ffpyplayer_codecs/__init__.py"
