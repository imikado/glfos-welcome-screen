import re

import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Pango', '1.0')
from gi.repository import Gtk, GLib, Pango

from infrastructure.api.launcher import launch_uri


class MarkdownRenderer:
    """Converts simple markdown (paragraphs, bullet lists, inline links) to GTK widgets."""

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
            lines = [l for l in block.splitlines() if l.strip()]
            if all(l.lstrip().startswith(('* ', '- ')) for l in lines):
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
