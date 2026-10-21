import os
import re

import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Pango', '1.0')
gi.require_version('Gdk', '4.0')
from gi.repository import Gtk, Gdk, GLib, Pango

from config import IMAGES_DIR
from infrastructure.api.launcher import launch_uri


class _ScaledPicture(Gtk.Picture):
    """Picture that fills the available width, its height following the image ratio."""

    def __init__(self, texture):
        super().__init__(paintable=texture)
        self._ratio = texture.get_height() / texture.get_width()

    def do_get_request_mode(self):
        return Gtk.SizeRequestMode.HEIGHT_FOR_WIDTH

    def do_measure(self, orientation, for_size):
        if orientation == Gtk.Orientation.HORIZONTAL:
            return 0, 0, -1, -1
        height = int(max(for_size, 0) * self._ratio)
        return height, height, -1, -1


class MarkdownRenderer:
    """Converts simple markdown (paragraphs, bullet lists, inline links, images) to GTK widgets."""

    @classmethod
    def render(cls, md_text: str) -> Gtk.Box:
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        box.set_hexpand(True)
        if not md_text.strip():
            return box
        for block in re.split(r'\n{2,}', md_text.strip()):
            block = block.strip()
            if not block:
                continue
            lines = [l.strip() for l in block.splitlines() if l.strip()]
            image = re.fullmatch(r'!\[([^\]]*)\]\(([^)]+)\)', ' '.join(lines))
            if image:
                picture = cls._render_image(image.group(2), image.group(1))
                if picture:
                    box.append(picture)
            elif all(l.lstrip().startswith(('* ', '- ')) for l in lines):
                box.append(cls._render_list(lines))
            else:
                box.append(cls._make_label(' '.join(lines)))
        return box

    @classmethod
    def _render_list(cls, lines) -> Gtk.Box:
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
        vbox.set_margin_start(8)
        vbox.set_hexpand(True)
        for line in lines:
            text = re.sub(r'^[\*\-]\s+', '', line.lstrip())
            row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
            row.set_hexpand(True)
            bullet = Gtk.Label(label='•')
            bullet.set_valign(Gtk.Align.START)
            bullet.set_margin_top(1)
            row.append(bullet)
            row.append(cls._make_label(text))
            vbox.append(row)
        return vbox

    @staticmethod
    def _render_image(filename, alt):
        path = os.path.join(IMAGES_DIR, filename)
        if not os.path.exists(path):
            return None
        try:
            texture = Gdk.Texture.new_from_filename(path)
        except GLib.Error:
            return None
        picture = _ScaledPicture(texture)
        picture.set_content_fit(Gtk.ContentFit.CONTAIN)
        picture.set_hexpand(True)
        picture.set_alternative_text(alt)
        picture.set_margin_top(8)
        picture.set_margin_bottom(8)
        return picture

    @classmethod
    def _make_label(cls, text: str) -> Gtk.Label:
        parts = re.split(r'(\[[^\]]+\]\([^)]+\))', text)
        markup_parts = []
        for part in parts:
            m = re.fullmatch(r'\[([^\]]+)\]\(([^)]+)\)', part)
            if m:
                link_text = GLib.markup_escape_text(m.group(1))
                href = GLib.markup_escape_text(m.group(2))
                markup_parts.append(f'<a href="{href}">{link_text}</a>')
            else:
                markup_parts.append(GLib.markup_escape_text(part))
        label = Gtk.Label()
        label.set_markup(''.join(markup_parts))
        label.set_xalign(0.0)
        label.set_wrap(True)
        label.set_wrap_mode(Pango.WrapMode.WORD_CHAR)
        label.set_hexpand(True)
        label.connect('activate-link', cls._on_activate_link)
        return label

    @staticmethod
    def _on_activate_link(_label, uri):
        launch_uri(uri)
        return True
