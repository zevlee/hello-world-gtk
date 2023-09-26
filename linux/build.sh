#!/bin/sh

. ../INFO

if [ ! -d ../venv ]; then
	echo "Setting up virtual environment..."
	python3 -m venv --system-site-packages venv
	. venv/bin/activate
	python3 -m pip install --upgrade pip
	python3 -m pip install -r ../requirements.txt
else
	. ../venv/bin/activate
fi

echo "Running pyinstaller..."

python3 -OO -m PyInstaller $APP.spec --noconfirm

echo "Preparing app..."

VERSION=$(cat ../VERSION)
mv dist/$APP/$APP dist/$APP/AppRun
sed -i "s/X-AppImage-Version=VERSION/X-AppImage-Version="$VERSION"/g" dist/$APP/_internal/$APP.desktop
ln -s _internal/$APP.desktop dist/$APP/$APP.desktop
ln -s _internal/$ICON dist/$APP/$ICON
wget https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-$(uname -m).AppImage
chmod +x appimagetool-$(uname -m).AppImage

echo "Running appimagetool..."

ARCH=$(uname -m) ./appimagetool-$(uname -m).AppImage dist/$APP
rm appimagetool-$(uname -m).AppImage
mv *.AppImage $APP-$VERSION-$(uname -m).AppImage
echo $(sha256sum $APP-$VERSION-$(uname -m).AppImage) > $APP-$VERSION-$(uname -m).AppImage.sha256

echo "Cleaning up..."

deactivate
rm -r build dist
if [ ! -d ../venv ]; then
	rm -r venv
fi
mv $APP-$VERSION-$(uname -m).AppImage* ../..
