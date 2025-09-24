from libqtile import bar, layout, qtile
from libqtile import widget as d_widget
from qtile_extras import widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from qtile_extras.widget.bluetooth import Bluetooth
from qtile_extras.widget.decorations import RectDecoration, BorderDecoration
from utils import *

from widgets import SingBoxStatus

widget_radius = 0
wallpaper = "~/.config/wallpapers/planet.jpg"

sep_config = {
    "size_percent": 0,
    "padding": 8,
}

sing_box_widget = SingBoxStatus(
    foreground="#928374",
    start_cmd=[
        "/home/miron/repos/vpn/sing-box/sing-box",
        "run",
        "-c",
        "/home/miron/repos/vpn/sing-box/config.json",
    ],
    update_interval=5,
)


def create_bar(fontsize):
    return bar.Bar(
        [
            widget.GroupBox(
                borderwidth=0,
                block_highlight_text_color="#fabd2f",
                active="#928374",
                inactive="#928374",
                disable_drag=True,
                fontsize=fontsize,
                padding_x=0,
                margin_x=50,
            ),
            widget.Spacer(),
            widget.Net(
                format="{down:.0f}{down_suffix} ↓↑ {up:.0f}{up_suffix}",
                foreground="#928374",
            ),
            sing_box_widget,
            widget.Sep(**sep_config),
            widget.Clock(
                format="󰥔 %I:%M",
                foreground="#928374",
                fontsize=fontsize,
            ),
            widget.Sep(**sep_config),
            widget.Memory(
                fontsize=fontsize,
                format="󰍛 {MemUsed:.0f}{mm}",
                foreground="#928374",
            ),
            widget.Sep(**sep_config),
            widget.CPU(
                fontsize=fontsize,
                format="󰘚 {load_percent}%",
                foreground="#928374",
            ),
            widget.Sep(**sep_config),
            widget.Sep(**sep_config),
            widget.Battery(
                fontsize=fontsize,
                format="{char} {percent:2.0%}",
                charge_char="󰂄",
                discharge_char="󰁹",
                empty_char="󰂃",
                full_char="󰁹",
                show_short_text=False,
                not_charging_char="󰁹",
                foreground="#928374",
            ),
            widget.Sep(**sep_config),
            widget.Volume(device="pulse", foreground="#928374", fmt="{}"),
            widget.Sep(**sep_config),
            widget.Backlight(
                fontsize=fontsize,
                fmt="󰃚 {}",
                backlight_name=get_backlight_device(),
                foreground="#928374",
            ),
            widget.Sep(**sep_config),
            widget.KeyboardLayout(
                fontsize=fontsize,
                configured_keyboards=["us", "ru"],
                foreground="#928374",
            ),
        ],
        fontsize,
        opacity=1,
        background="#282828",
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
