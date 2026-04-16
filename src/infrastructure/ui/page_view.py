import os

import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Gdk", "4.0")
from gi.repository import Gtk, Gdk, GLib

from config import IMAGES_DIR
from infrastructure.api.launcher import launch_uri
from infrastructure.ui.markdown_renderer import MarkdownRenderer


def _picture_in_box(path, size):
    """
    Wrap a Gtk.Picture in a fixed-size Gtk.Box so GTK handles HiDPI scaling
    natively (no pre-rasterisation, no blur on fractional/HiDPI displays).
    """
    box = Gtk.Box()
    box.set_size_request(size, size)
    box.set_halign(Gtk.Align.CENTER)
    box.set_valign(Gtk.Align.CENTER)
    box.set_hexpand(False)
    box.set_vexpand(False)
    box.set_overflow(Gtk.Overflow.HIDDEN)

    picture = Gtk.Picture.new_for_filename(path)
    picture.set_content_fit(Gtk.ContentFit.CONTAIN)
    picture.set_can_shrink(True)
    box.append(picture)

    return box


def make_page_image(filename, size=128):
    """Page content header image — HiDPI-aware, centred at size×size."""
    path = os.path.join(IMAGES_DIR, filename)
    if not os.path.exists(path):
        return None
    try:
        return _picture_in_box(path, size)
    except GLib.Error:
        return None


def make_menu_icon(filename):
    """Sidebar menu icon — natural size, vertically centred."""
    path = os.path.join(IMAGES_DIR, filename)
    if not os.path.exists(path):
        return None
    try:
        texture = Gdk.Texture.new_from_filename(path)
        img = Gtk.Image.new_from_paintable(texture)
        img.set_halign(Gtk.Align.CENTER)
        img.set_valign(Gtk.Align.CENTER)
        return img
    except GLib.Error:
        return None


def theme_image_name(page_cfg, key, dark):
    """Return the theme-appropriate image filename for a page config key."""
    dark_key = key + "_dark"
    if dark and dark_key in page_cfg:
        return page_cfg[dark_key]
    return page_cfg.get(key, "")


def build_page(loc, page_cfg, style_manager):
    scroll = Gtk.ScrolledWindow()
    scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
    scroll.set_hexpand(True)
    scroll.set_vexpand(True)

    content = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
    content.set_margin_start(28)
    content.set_margin_end(28)
    content.set_margin_top(20)
    content.set_margin_bottom(20)
    content.set_hexpand(True)
    scroll.set_child(content)

    # Image
    image_file = theme_image_name(page_cfg, "image", style_manager.get_dark())
    if image_file:
        img_widget = make_page_image(image_file)
        if img_widget:
            img_widget.set_margin_bottom(4)
            command = page_cfg.get("command", "")
            if command:
                wrapper = Gtk.Box()
                wrapper.set_halign(Gtk.Align.CENTER)
                wrapper.append(img_widget)
                gesture = Gtk.GestureClick.new()
                gesture.connect("released", lambda *_: launch_uri(command))
                wrapper.add_controller(gesture)
                wrapper.set_cursor(Gdk.Cursor.new_from_name("pointer", None))
                content.append(wrapper)
            else:
                wrapper = Gtk.Box()
                wrapper.set_halign(Gtk.Align.CENTER)
                wrapper.append(img_widget)
                content.append(wrapper)

    # Title
    title_key = page_cfg.get("title_key", "")
    if title_key:
        title = Gtk.Label(label=loc.tr(title_key))
        title.add_css_class("title-2")
        title.set_halign(Gtk.Align.CENTER)
        title.set_margin_top(30)
        title.set_margin_bottom(20)
        content.append(title)

    # Body
    body_text = loc.markdown(page_cfg.get("body_key", ""))
    body_widget = MarkdownRenderer.render(body_text)
    body_widget.set_margin_top(4)
    content.append(body_widget)

    return scroll


def build_sidebar_row(loc, page_cfg, dark):
    row = Gtk.ListBoxRow()
    row.set_activatable(True)

    box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
    box.set_margin_start(10)
    box.set_margin_end(10)
    box.set_margin_top(7)
    box.set_margin_bottom(7)

    icon_file = theme_image_name(page_cfg, "menu_icon", dark)
    if icon_file:
        icon_widget = make_menu_icon(icon_file)
        if icon_widget:
            box.append(icon_widget)

    label = Gtk.Label(label=loc.tr(page_cfg["menu_key"]))
    label.set_xalign(0.0)
    label.set_hexpand(True)
    box.append(label)

    row.set_child(box)
    return row
