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
    app = WelcomeApp()
    sys.exit(app.run(sys.argv))


if __name__ == '__main__':
    main()
