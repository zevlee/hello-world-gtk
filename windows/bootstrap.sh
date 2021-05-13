#!/bin/sh

# This script is meant to be run through MinGW

pacman -Sy --noconfirm mingw-w64-i686-gtk3 mingw-w64-i686-python3 mingw-w64-i686-python3-gobject mingw-w64-i686-nsis zip unzip

pacman -Sy --noconfirm mingw-w64-i686-python3-pip
pip install pyinstaller

mkdir zipdll
cd zipdll
wget https://nsis.sourceforge.io/mediawiki/images/d/d9/ZipDLL.zip
unzip ZipDLL.zip
cp ZipDLL.dll /mingw32/share/nsis/Plugins/ansi
cp ZipDLL.dll /mingw32/share/nsis/Plugins/unicode
cp zipdll.nsh /mingw32/share/nsis/Include/ZipDLL.nsh
cd ..
rm -r zipdll

echo "Done"
