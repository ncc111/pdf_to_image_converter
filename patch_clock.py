import io

p = '/root/clock_app/clock_android.py'
s = io.open(p, encoding='utf-8').read()

old = (
    'import os\n'
    '# Force Kivy to use the native Android video provider (avoids ffpyplayer dependency)\n'
    'os.environ.setdefault("KIVY_VIDEO", "android")\n'
)
new = (
    'import os\n'
    '# Video is provided by ffpyplayer (built via local p4a recipes: FFmpeg n4.3.1).\n'
    '# Do NOT set KIVY_VIDEO=android -- there is no such provider in stock Kivy.\n'
)

if old not in s:
    raise SystemExit('PATTERN-NOT-FOUND')
s = s.replace(old, new)
io.open(p, 'w', encoding='utf-8', newline='\n').write(s)
print('patched clock_android.py header OK')
