#!/bin/sh

# This script is meant to be run through MinGW

pacman -S --noconfirm mingw-w64-i686-gtk3 mingw-w64-i686-python3 mingw-w64-i686-python3-gobject mingw-w64-i686-nsis zip unzip
pacman -S --noconfirm mingw-w64-i686-python3-pip
wget https://nsis.sourceforge.io/mediawiki/images/5/5a/NSISunzU.zip
unzip NSISunzU.zip
cp "NSISunzU/Plugin unicode/nsisunz.dll" /mingw32/share/nsis/Plugins/unicode
rm -r NSISunzU*

echo "Done"
