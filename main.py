import os
import traceback


def _prepare_env():
    """Set writable KIVY_HOME before Kivy is imported.

    On Android the default KIVY_HOME becomes ANDROID_APP_PATH/.kivy, which can
    be read-only and makes `import kivy` crash while copying its icon files
    (shutil.Error / PermissionError). Point it at a directory we create and
    know is writable: the app working dir (cwd, .../files/app on p4a).
    """
    candidates = [
        os.environ.get("ANDROID_PRIVATE"),   # .../files (internal storage root) - writable
        os.environ.get("ANDROID_APP_PATH"),
        os.getcwd(),                          # p4a chdir's here (.../files/app)
        os.path.expanduser("~"),
    ]
    kivy_home = None
    for base in candidates:
        if not base:
            continue
        candidate = os.path.join(base, ".kivy")
        try:
            # Mimic what Kivy does: create .kivy/icon and write a file in it.
            icon_dir = os.path.join(candidate, "icon")
            os.makedirs(icon_dir, exist_ok=True)
            probe = os.path.join(icon_dir, ".write_test")
            with open(probe, "w") as fh:
                fh.write("ok")
            os.remove(probe)
            kivy_home = candidate
            break
        except Exception:
            continue
    if kivy_home is None:
        # Last resort: a private temp dir that is always writable.
        import tempfile
        kivy_home = os.path.join(tempfile.gettempdir(), ".kivy")
        try:
            os.makedirs(os.path.join(kivy_home, "icon"), exist_ok=True)
        except Exception:
            pass
    os.environ["KIVY_HOME"] = kivy_home
    # Do NOT set KIVY_VIDEO=android: there is no such provider in stock Kivy,
    # and leaving it forces Kivy to report "Unknown <android> provider".
    # Video playback is handled by ffpyplayer (auto-selected).


def _run():
    _prepare_env()
    from clock_android import ClockApp
    ClockApp().run()


# Android/p4a entry point. p4a requires a file literally named main.py.
# Wrap startup so any exception is written to a log we can pull with adb,
# instead of the app silently dying at launch.
if __name__ == "__main__":
    try:
        _run()
    except Exception:
        tb = traceback.format_exc()
        base = (
            os.environ.get("ANDROID_PRIVATE")
            or os.environ.get("ANDROID_APP_PATH")
            or "/sdcard"
        )
        try:
            with open(os.path.join(base, "clock_crash.log"), "w") as fh:
                fh.write(tb)
        except Exception:
            pass
        # Also emit to logcat via print so the 'python' tag captures it.
        print("CLOCK_APP_STARTUP_CRASH\n" + tb)
        raise
