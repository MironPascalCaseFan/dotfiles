import os
from libqtile import hook

@hook.subscribe.startup_once
def autostart():
    autostartup = [
        'setxkbmap -layout "us,ru"',
        'keymapper -u &',
        # "picom &",
        'dunst &',
        'xinput set-prop "ELAN2310:00 04F3:3238 Touchpad" "libinput Tapping Enabled" 1',
        'xinput set-prop "ELAN2310:00 04F3:3238 Touchpad" "libinput Natural Scrolling Enabled" 1',
        "anki &",
        "wezterm &",
        "google-chrome &"
    ]

    for cmd in autostartup:
        os.system(cmd)
