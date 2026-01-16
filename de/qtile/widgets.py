from libqtile.widget import base
import subprocess


class SingBoxStatus(base.InLoopPollText):
    defaults = [
        ("update_interval", 5, "How often to check (seconds)"),
        ("active_text", "Proxy ON", "Text when sing-box is running"),
        ("inactive_text", "Proxy OFF", "Text when sing-box is not running"),
        ("start_cmd", ["sing-box", "run"], "Command to start sing-box"),
        ("stop_cmd", ["pkill", "-2", "-f", "sing-box"], "Command to kill ALL sing-box processes"),
    ]

    def __init__(self, **config):
        super().__init__("", **config)
        self.add_defaults(self.defaults)

    def poll(self):
        try:
            subprocess.check_output(["pgrep", "-f", "sing-box"])
            return self.active_text
        except subprocess.CalledProcessError:
            return self.inactive_text

    def button_press(self, x, y, button):
        if button == 1:
            self.toggle_proxy()

    def toggle_proxy(self):
        try:
            subprocess.check_output(["pgrep", "-f", "sing-box"])
            subprocess.Popen(self.stop_cmd)
        except subprocess.CalledProcessError:
            subprocess.Popen(self.start_cmd)

        self.tick()  # force refresh
