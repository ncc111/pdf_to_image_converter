build_py = '/root/clock_app/.buildozer/android/platform/python-for-android/pythonforandroid/build.py'

with open(build_py, 'r') as f:
    content = f.read()

# Pin pip to <25.1 so the open_rich_spinner import error doesn't occur.
# pip 25.1+ requires internal modules incompatible with py3.11 bootstrap here.
old = '"source venv/bin/activate && python -m ensurepip --upgrade && python -m pip install -U pip"'
new = '"source venv/bin/activate && python -m ensurepip --upgrade && python -m pip install \'pip==24.3.1\'"'

if old in content:
    content = content.replace(old, new)
    with open(build_py, 'w') as f:
        f.write(content)
    print('Patched pip version pin successfully')
else:
    lines = content.splitlines()
    for i, l in enumerate(lines[870:892], start=871):
        print(i, repr(l))
    print('OLD STRING NOT FOUND')
