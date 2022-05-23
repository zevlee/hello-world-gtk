#!/bin/sh

APP=hello-world-gtk

echo "Setting up virtual environment..."

python3 -m venv --system-site-packages venv
. venv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install -r ../requirements.txt

echo "Running pyinstaller..."

python3 -OO -m PyInstaller $APP.spec --noconfirm

echo "Preparing app..."

version=$(cat ../VERSION)
mv dist/$APP/$APP dist/$APP/AppRun
sed -i "s/X-AppImage-Version=VERSION/X-AppImage-Version="$version"/g" dist/$APP/$APP.desktop
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$(uname -m).AppImage
chmod +x appimagetool-$(uname -m).AppImage

echo "Running appimagetool..."

ARCH=$(uname -m) ./appimagetool-$(uname -m).AppImage dist/$APP
rm appimagetool-$(uname -m).AppImage
mv *.AppImage $APP-$version-$(uname -m).AppImage
echo $(sha256sum $APP-$version-$(uname -m).AppImage) > $APP-$version-$(uname -m).AppImage.sha256

echo "Cleaning up..."

deactivate
rm -r build dist venv
mv $APP-$version-$(uname -m).AppImage* ../..
