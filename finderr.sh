#!/bin/bash
LOG=/root/clock_app/build_ffpy.log
echo "=== first error/undeclared/fatal lines ==="
grep -nE "error:|fatal error:|undeclared|undefined|Cython|\.pyx|No such file|cannot find" "$LOG" | head -40
