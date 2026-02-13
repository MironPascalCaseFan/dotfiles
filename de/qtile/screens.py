from libqtile import bar, layout, qtile
from libqtile import widget as widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from utils import *

from widgets import SingBoxStatus

widget_radius = 0
wallpaper = "~/.config/wallpapers/literallymewallpapernatural.jpg"

sep_config = {
    "size_percent": 0,
    "padding": 8,
}

text_fg = "#FDFBD4"
bar_background = "#aec1eb"

sing_box_widget = SingBoxStatus(
    foreground=text_fg,
    start_cmd=[
        "/home/miroshQa/realhome/tools/sing-box/sing-box",
        "run",
        "-c",
        "/home/miroshQa/realhome/tools/sing-box/config.json",
    ],
    update_interval=5,
)


def create_bar(fontsize):
    return bar.Bar(
        [
            widget.GroupBox(
                borderwidth=0,
                block_highlight_text_color="#F7CA18",
                active=text_fg,
                inactive=text_fg,
                disable_drag=True,
                fontsize=fontsize,
                padding_x=0,
                margin_x=50,
            ),
            widget.Spacer(),
            widget.Net(
                format="{down:.0f}{down_suffix} ↓↑ {up:.0f}{up_suffix}",
                foreground=text_fg,
            ),
            sing_box_widget,
            widget.Sep(**sep_config),
            widget.Clock(
                format="󰥔 %I:%M",
                foreground=text_fg,
                fontsize=fontsize,
            ),
            widget.Sep(**sep_config),
            widget.Memory(
                fontsize=fontsize,
                format="󰍛 {MemUsed:.0f}{mm}",
                foreground=text_fg,
            ),
            widget.Sep(**sep_config),
            widget.CPU(
                fontsize=fontsize,
                format="󰘚 {load_percent}%",
                foreground=text_fg,
            ),
            widget.ThermalSensor(
                fontsize=fontsize,
                foreground=text_fg,
            ),
            widget.Sep(**sep_config),
            widget.Sep(**sep_config),
            widget.Battery(
                fontsize=fontsize,
                format="{char} {percent:2.0%} {watt:.1f} W",
                charge_char="󰂄",
                discharge_char="󰁹",
                empty_char="󰂃",
                full_char="󰁹",
                show_short_text=False,
                not_charging_char="󰁹",
                foreground=text_fg,
            ),
            widget.Sep(**sep_config),
            widget.Volume(device="pulse", foreground=text_fg, fmt="{}"),
            widget.Sep(**sep_config),
            widget.Backlight(
                fontsize=fontsize,
                fmt="󰃚 {}",
                backlight_name=get_backlight_device(),
                foreground=text_fg,
            ),
            widget.Sep(**sep_config),
            widget.KeyboardLayout(
                fontsize=fontsize,
                configured_keyboards=["us", "ru"],
                foreground=text_fg,
            ),
        ],
        fontsize,
        opacity=1,
        background=bar_background,
    )


screens = [
    Screen(
        top=create_bar(fontsize=50),
        x11_drag_polling_rate=120,
        wallpaper=wallpaper,
        wallpaper_mode="fill",
    ),
    Screen(
        top=create_bar(fontsize=40),
        x11_drag_polling_rate=120,
        wallpaper=wallpaper,
        wallpaper_mode="fill",
    ),
]
