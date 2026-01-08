from libqtile.lazy import lazy
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from screens import sing_box_widget

mod = "mod4"
terminal = "wezterm"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),

    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # mod1 means alt key
    Key([mod, "mod1"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "mod1"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "mod1"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "mod1"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    Key([mod], "g", lazy.spawn("/home/miron/realhome/tools/r-quick-share.AppImage"), desc="Get (quick share)"),

    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "s", lazy.spawn("flameshot gui"), desc="Launch terminal"),
    Key([mod], "period",
                lazy.spawn("sh -c 'i3lock -i ~/.config/wallpapers/lockscreen.png && sleep 0.1 && xset dpms force off'"),
                desc="Lock screen and turn off monitor"
    ),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window"),

    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Spawn a command using a prompt widget"),
    Key([mod], "a", lazy.spawn("rofi -show window"), desc="Spawn a command using a prompt widget"),

    Key([mod], "space",  lazy.widget["keyboardlayout"].next_keyboard()),
    # https://github.com/i3/i3/discussions/4763
    # chmod helps
    Key([mod, "shift"], "bracketright", lazy.spawn("brightnessctl set +10%")),
    Key([mod, "shift"], "bracketleft", lazy.spawn("brightnessctl set 10%-")),

    # pulseaudio required
    Key([mod], "m", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    Key([mod], "bracketright", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +10%")),
    Key([mod], "bracketleft", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -10%")),

    Key([mod], "p", lazy.function(lambda qtile: sing_box_widget.toggle_proxy()))
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

groups = []

groups.append(Group("1", label="D"))
groups.append(Group("2", label=""))
groups.append(Group("3", label="󰈹"))
groups.append(Group("4", label="A"))
groups.append(Group("5", label="󰉋"))
groups.append(Group("6", label="6"))
groups.append(Group("7", label="7"))
groups.append(Group("8", label="8"))
groups.append(Group("9", label="9"))

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
        ]
    )
