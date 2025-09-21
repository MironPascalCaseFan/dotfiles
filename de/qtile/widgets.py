from libqtile.widget import base
import subprocess

from libqtile.widget import base
import subprocess

class SingBoxStatus(base.ThreadPoolText):
    defaults = [
        ("update_interval", 5, "How often to check (seconds)"),
        ("active_text", "Proxy ON", "Text when sing-box is running"),
        ("inactive_text", "Proxy OFF", "Text when sing-box is not running"),
        ("start_cmd", ["sing-box", "run"], "Command to start sing-box"),
        ("stop_cmd", ["pkill", "-2", "-f", "sing-box"], "Command to kill ALL sing-box processes"),
    ]

    def __init__(self, **config):
        super().__init__("", **config)
        self.add_defaults(SingBoxStatus.defaults)

    def poll(self):
        """Check if sing-box is running and return status text"""
        try:
            subprocess.check_output(["pgrep", "-f", "sing-box"])
            return self.active_text
        except subprocess.CalledProcessError:
            return self.inactive_text

    def button_press(self, x, y, button):
        """Toggle sing-box on left-click"""
        self.toggle_proxy()

    def toggle_proxy(self):
        """Toggle proxy by checking process state directly"""
        try:
            # If any sing-box process exists, stop it
            subprocess.check_output(["pgrep", "-f", "sing-box"])
            subprocess.Popen(self.stop_cmd)
        except subprocess.CalledProcessError:
            # If no process found, start it
            subprocess.Popen(self.start_cmd)
        
        self._update()  # refresh immediately
