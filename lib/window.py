#!/usr/bin/env python3

from gi import require_versions
require_versions({"Gtk": "3.0"})
from gi.repository import Gtk


class Window(Gtk.ApplicationWindow):

    def __init__(self, app):
        super().__init__(application=app)
        self.set_title("Hello World")
