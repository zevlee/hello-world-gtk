#!/bin/sh

# This script is meant to be run through MinGW

pacman -S --noconfirm mingw-w64-$(uname -m)-gtk4 mingw-w64-$(uname -m)-python-pip mingw-w64-$(uname -m)-python3-gobject mingw-w64-$(uname -m)-libadwaita mingw-w64-$(uname -m)-nsis mingw-w64-$(uname -m)-nsis-nsisunz mingw-w64-$(uname -m)-gcc zip unzip

echo "Done"
