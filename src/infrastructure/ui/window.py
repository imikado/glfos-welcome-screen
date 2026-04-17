import os

import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
gi.require_version("Gio", "2.0")
from gi.repository import Gtk, Adw, Gio

from config import VERSION, APP_ID, PAGES, AUTOSTART_DIR, AUTOSTART_FILE, DESKTOP_ENTRY
from infrastructure.api.localization import LocalizationApi
from infrastructure.ui.page_view import build_page, build_sidebar_row


class WelcomeWindow(Adw.ApplicationWindow):
    def __init__(self, app, loc: LocalizationApi):
        super().__init__(application=app)
        self.loc = loc
        self.style_manager = Adw.StyleManager.get_default()

        self.set_title(loc.tr("app_title"))
        self.set_default_size(1000, 600)
        self.set_size_request(800, 350)

        self._build_ui()

    def _build_ui(self):
        toolbar_view = Adw.ToolbarView()
        self.set_content(toolbar_view)

        header = Adw.HeaderBar()

        theme_btn = Gtk.Button(icon_name="weather-clear-night-symbolic")
        theme_btn.add_css_class("flat")
        theme_btn.set_tooltip_text("Toggle dark/light theme")
        theme_btn.connect("clicked", self._on_toggle_theme)
        header.pack_start(theme_btn)

        version_lbl = Gtk.Label(label=VERSION)
        version_lbl.add_css_class("dim-label")
        version_lbl.set_margin_start(4)
        version_lbl.set_margin_end(4)
        header.pack_end(version_lbl)

        toolbar_view.add_top_bar(header)

        body = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        toolbar_view.set_content(body)

        paned = Gtk.Paned(orientation=Gtk.Orientation.HORIZONTAL)
        paned.set_vexpand(True)
        paned.set_hexpand(True)
        paned.set_position(220)
        paned.set_shrink_start_child(False)
        paned.set_shrink_end_child(False)

        sidebar_scroll = Gtk.ScrolledWindow()
        sidebar_scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        sidebar_scroll.set_size_request(160, -1)
        sidebar_scroll.set_vexpand(True)

        self._listbox = Gtk.ListBox()
        self._listbox.add_css_class("navigation-sidebar")
        self._listbox.set_selection_mode(Gtk.SelectionMode.SINGLE)
        self._listbox.set_vexpand(True)
        self._listbox.connect("row-selected", self._on_row_selected)
        sidebar_scroll.set_child(self._listbox)

        paned.set_start_child(sidebar_scroll)

        self._stack = Gtk.Stack()
        self._stack.set_transition_type(Gtk.StackTransitionType.CROSSFADE)
        self._stack.set_transition_duration(100)
        self._stack.set_hexpand(True)
        self._stack.set_vexpand(True)
        paned.set_end_child(self._stack)

        body.append(paned)

        dark = self.style_manager.get_dark()
        for page_cfg in PAGES:
            self._listbox.append(build_sidebar_row(self.loc, page_cfg, dark))
            self._stack.add_named(
                build_page(self.loc, page_cfg, self.style_manager), page_cfg["id"]
            )

        self._listbox.select_row(self._listbox.get_row_at_index(0))

        body.append(Gtk.Separator(orientation=Gtk.Orientation.HORIZONTAL))

        bottom = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        bottom.set_margin_start(12)
        bottom.set_margin_end(12)
        bottom.set_margin_top(6)
        bottom.set_margin_bottom(6)

        self._check = Gtk.CheckButton(label=self.loc.tr("bottom_show_window_next_time"))
        self._check.set_active(not os.path.exists(AUTOSTART_FILE))
        self._check.connect("toggled", self._on_autostart_toggled)
        bottom.append(self._check)
        body.append(bottom)

    def _on_row_selected(self, _listbox, row):
        if row is not None:
            self._stack.set_visible_child_name(PAGES[row.get_index()]["id"])

    def _on_toggle_theme(self, _btn):
        sm = self.style_manager
        if sm.get_dark():
            sm.set_color_scheme(Adw.ColorScheme.FORCE_LIGHT)
        else:
            sm.set_color_scheme(Adw.ColorScheme.FORCE_DARK)

    def _on_autostart_toggled(self, check):
        if check.get_active():
            try:
                os.remove(AUTOSTART_FILE)
            except FileNotFoundError:
                pass
        else:
            os.makedirs(AUTOSTART_DIR, exist_ok=True)
            with open(AUTOSTART_FILE, "w") as f:
                f.write(DESKTOP_ENTRY)


class WelcomeApp(Adw.Application):
    def __init__(self):
        super().__init__(
            application_id=APP_ID,
            flags=Gio.ApplicationFlags.DEFAULT_FLAGS,
        )
        self.connect("activate", self._on_activate)

    def _on_activate(self, _app):
        win = WelcomeWindow(self, LocalizationApi())
        win.present()
