#!/bin/bash
set -e
LOCAL=/root/clock_app/recipes

# --- ffmpeg: replace with known-good n4.3.1 recipe ---
rm -rf "$LOCAL/ffmpeg"
mkdir -p "$LOCAL/ffmpeg/patches"
tr -d '\r' < /mnt/c/Users/IvanNG/.cline/data/workspaces/chat/ffmpeg_init.py > "$LOCAL/ffmpeg/__init__.py"
tr -d '\r' < /mnt/c/Users/IvanNG/.cline/data/workspaces/chat/ffmpeg_configure.patch > "$LOCAL/ffmpeg/patches/configure.patch"

# --- ffpyplayer: keep p4a's v4.5.1 (compatible with ffmpeg 4.3.x). Remove our
#     earlier v4.5.3 bump so we stay on the tested pairing. ---
if [ -f "$LOCAL/ffpyplayer/__init__.py" ]; then
  sed -i "s/version = 'v4.5.3'/version = 'v4.5.1'/" "$LOCAL/ffpyplayer/__init__.py"
fi

echo "=== ffmpeg version ==="
grep -n "version =" "$LOCAL/ffmpeg/__init__.py" | head -1
echo "=== ffmpeg patches dir ==="
ls "$LOCAL/ffmpeg/patches"
echo "=== ffpyplayer version ==="
grep -n "version =" "$LOCAL/ffpyplayer/__init__.py" | head -1
echo "=== local recipes tree ==="
find "$LOCAL" -maxdepth 2 -type f | sort
