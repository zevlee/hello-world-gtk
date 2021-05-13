#!/bin/sh

app=hello-world-gtk
version=0.1.0

echo "Running pyinstaller..."

python3 -OO -m PyInstaller $app.spec --noconfirm

mv dist/$app/$app dist/$app/AppRun

wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$(uname -m).AppImage
chmod +x appimagetool-$(uname -m).AppImage

echo "Running appimagetool..."

./appimagetool*AppImage dist/$app

rm appimagetool-$(uname -m).AppImage

mv *.AppImage $app-$version-$(uname -m).AppImage

echo $(sha256sum $app-$version-$(uname -m).AppImage) > $app-$version-$(uname -m).AppImage.sha256

echo "Cleaning up..."

rm -r build dist

mv $app-$version-$(uname -m).AppImage* ../..
