from libqtile import bar, layout, qtile, widget
from libqtile.lazy import lazy
import autostart

from libqtile.config import Click, Drag, Group, Key, Match, Screen

from keys import mod, keys, groups
from screens import screens



layouts = [
    layout.Columns(
        border_width=5,
        margin=0,
        border_focus="#fabd2f",
        border_normal="#928374",
    ),
]

widget_defaults = dict(
    font="Hack Nerd Font Mono",
    fontsize=30,
    padding=20,
)

extension_defaults = widget_defaults.copy()


dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    border_focus="#f7e3b0",
    border_width=5,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wmname = "LG3D"
