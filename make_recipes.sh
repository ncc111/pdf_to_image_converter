#!/bin/bash
set -e
P4A=/root/clock_app/.buildozer/android/platform/python-for-android/pythonforandroid/recipes
LOCAL=/root/clock_app/recipes
mkdir -p "$LOCAL"

# Copy the two recipes we need to override
rm -rf "$LOCAL/ffmpeg" "$LOCAL/ffpyplayer"
cp -r "$P4A/ffmpeg" "$LOCAL/ffmpeg"
cp -r "$P4A/ffpyplayer" "$LOCAL/ffpyplayer"

# Pin FFmpeg to 6.1.2 (compatible with ffpyplayer 4.5.x)
sed -i "s/version = '8.0.1'/version = '6.1.2'/" "$LOCAL/ffmpeg/__init__.py"

# Bump ffpyplayer to v4.5.3 (adds aarch64 support, FFmpeg 6 compat)
sed -i "s/version = 'v4.5.1'/version = 'v4.5.3'/" "$LOCAL/ffpyplayer/__init__.py"

echo "=== ffmpeg version now ==="
grep -n "version =" "$LOCAL/ffmpeg/__init__.py" | head -1
echo "=== ffpyplayer version now ==="
grep -n "version =" "$LOCAL/ffpyplayer/__init__.py" | head -1
echo "=== ffmpeg patches referenced ==="
grep -n "patches" "$LOCAL/ffmpeg/__init__.py"
echo "=== ffmpeg patch files present? ==="
ls "$LOCAL/ffmpeg/patches" 2>/dev/null || echo "no patches dir"
echo "=== ffpyplayer patch files present? ==="
ls "$LOCAL/ffpyplayer/" 2>/dev/null
