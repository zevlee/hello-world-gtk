#!/bin/sh

# This script is meant to be run through MinGW

pacman -S --noconfirm mingw-w64-x86_64-gtk4 mingw-w64-x86_64-python-pip mingw-w64-x86_64-python3-gobject mingw-w64-x86_64-libadwaita mingw-w64-x86_64-nsis mingw-w64-x86_64-nsis-nsisunz zip unzip

echo "Done"
