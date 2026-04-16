import subprocess

import gi
gi.require_version('Gio', '2.0')
gi.require_version('GLib', '2.0')
from gi.repository import Gio, GLib


def launch_uri(uri):
    if not uri:
        return
    if uri.startswith('flatpak://'):
        app_id = uri[len('flatpak://'):]
        subprocess.Popen(['flatpak', 'run', app_id])
    elif uri.startswith('bash://'):
        cmd = uri[len('bash://'):]
        subprocess.Popen(['bash', '-lc', f'env -u LD_LIBRARY_PATH {cmd}'])
    elif uri.startswith('bashWithPrivilege://'):
        cmd = uri[len('bashWithPrivilege://'):]
        subprocess.Popen(['pkexec', cmd])
    elif uri.startswith(('http://', 'https://')):
        try:
            Gio.AppInfo.launch_default_for_uri(uri, None)
        except GLib.Error:
            pass
