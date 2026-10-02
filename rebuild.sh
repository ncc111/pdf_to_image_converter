#!/bin/bash
set -e
cd /root/clock_app
# ~/.local/bin holds buildozer + cython in this environment but isn't on PATH
# in the non-login shell; add it so buildozer can find its tools.
export PATH="$HOME/.local/bin:$PATH"
echo "=== validate sources ==="
python3 -m py_compile /root/clock_app/clock_android.py && echo PY_OK
echo "=== assets ==="
ls -la /root/clock_app/builtin.mp4

BZ=""
if [ -z "$BZ" ]; then
  for c in "$HOME/.local/bin/buildozer" /usr/local/bin/buildozer /usr/bin/buildozer; do
    [ -x "$c" ] && BZ="$c" && break
  done
fi
if [ -z "$BZ" ]; then
  if python3 -c "import buildozer" 2>/dev/null; then
    BZ="python3 -m buildozer"
  fi
fi
echo "BUILDOZER=$BZ"
if [ -z "$BZ" ]; then
  echo "NO_BUILDOZER"
  exit 1
fi

echo "=== starting android debug build (python-only change) ==="
$BZ android debug 2>&1 | tail -n 40
echo "=== resulting apk ==="
ls -la bin/*.apk
echo "BUILD_DONE"
