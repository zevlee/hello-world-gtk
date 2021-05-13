#!/usr/bin/env python3

from os.path import join, dirname
from gi import require_version
require_version("Gtk", "3.0")
from gi.repository import Gtk


class AppWindow(Gtk.ApplicationWindow):

    def __init__(self, app):
        Gtk.Window.__init__(self, application=app)
        self.set_title("Hello World")
        self.set_icon_from_file(
            join(dirname(__file__), "..", "hello-world-gtk.svg")
        )
        self.set_border_width(20)

        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.add(vbox)

        image = Gtk.Image.new_from_file(
            join(dirname(__file__), "..", "hello-world-gtk.svg")
        )
        vbox.pack_start(image, False, False, 0)

        label = Gtk.Label(halign=Gtk.Align.CENTER)
        label.set_text("\"Hello\"")
        vbox.pack_start(label, False, False, 0)

        self.show_all()


class Application(Gtk.Application):

    def __init__(self):
        Gtk.Application.__init__(self)

    def do_startup(self):
        Gtk.Application.do_startup(self)

    def do_activate(self):
        win = AppWindow(self)
        win.present()
