#!/usr/bin/env python3

from gi import require_version
require_version("Gtk", "4.0")
require_version("Adw", "1")
from gi.repository import Gtk, Adw


class AppWindow(Gtk.ApplicationWindow):

    def __init__(self, app):
        super().__init__(application=app)
        self.set_title("Hello World")


class Application(Adw.Application):

    def __init__(self):
        super().__init__()

    def do_startup(self):
        Gtk.Application.do_startup(self)

    def do_activate(self):
        win = AppWindow(self)
        win.present()
