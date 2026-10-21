#!/usr/bin/env python3
"""GLF OS Welcome Screen — Python/GTK4 + libadwaita."""

import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')

from infrastructure.ui.window import WelcomeApp


def main():
    lang = None
    args = sys.argv[:]
    for i, arg in enumerate(args):
        if arg.startswith('--lang='):
            lang = arg.split('=', 1)[1]
            args.pop(i)
            break
        if arg == '--lang' and i + 1 < len(args):
            lang = args[i + 1]
            args.pop(i + 1)
            args.pop(i)
            break
    if lang:
        os.environ['LANG'] = lang
    app = WelcomeApp()
    sys.exit(app.run(args))


if __name__ == '__main__':
    main()
