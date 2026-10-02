#!/bin/bash
BZ=$(python3 -c 'import buildozer, os; print(os.path.dirname(buildozer.__file__))')
echo "buildozer dir: $BZ"
echo "=== local_recipes references in android target ==="
grep -rniE "local_recipes|local-recipes|--local-recipes" "$BZ/targets/android.py"
