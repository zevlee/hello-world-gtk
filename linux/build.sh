#!/bin/sh

APP=hello-world-gtk

version=$(cat ../VERSION)

echo "Running pyinstaller..."

python3 -OO -m PyInstaller $APP.spec --noconfirm

mv dist/$APP/$APP dist/$APP/AppRun
sed -i "s/X-AppImage-Version=VERSION/X-AppImage-Version="$version"/g" dist/$APP/$APP.desktop

wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$(uname -m).AppImage
chmod +x appimagetool-$(uname -m).AppImage

echo "Running appimagetool..."

ARCH=$(uname -m) ./appimagetool*AppImage dist/$APP

rm appimagetool-$(uname -m).AppImage

mv *.AppImage $APP-$version-$(uname -m).AppImage

echo $(sha256sum $APP-$version-$(uname -m).AppImage) > $APP-$version-$(uname -m).AppImage.sha256

echo "Cleaning up..."

rm -r build dist

mv $APP-$version-$(uname -m).AppImage* ../..
