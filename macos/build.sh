#!/bin/sh

APP=hello-world-gtk
NAME="Hello World"

if [ ! -d ../venv ]; then
	echo "Setting up virtual environment..."
	python3 -m venv --system-site-packages venv
	. venv/bin/activate
	python3 -m pip install --upgrade pip
	PYINSTALLER_COMPILE_BOOTLOADER=1 PYI_STATIC_ZLIB=1 python3 -m pip install -r ../requirements.txt
else
	. ../venv/bin/activate
fi

echo "Preparing app..."

version=$(cat ../VERSION)
cp "$APP.spec" "$APP@.spec"
sed -i '' "s/'VERSION'/'$version'/g" "$APP@.spec"
if [ ! -z "$1" ]; then
    sed -i '' "s/codesign_identity=''/codesign_identity='$1'/g" "$APP@.spec"
fi

echo "Running pyinstaller..."

python3 -OO -m PyInstaller "$APP@.spec" --noconfirm

if [ ! -z "$2" ]; then
    echo "Notarizing app..."
    cd dist
    ditto -ck --sequesterRsrc --keepParent "$NAME.app" "$APP-$version.zip"
    if [ ! -z "$3" ]; then
        xcrun notarytool submit "$APP-$version.zip" --apple-id "$2" --team-id "$3" --password "$4" --wait
    else
        xcrun notarytool submit "$APP-$version.zip" --keychain-profile "$2" --wait
    fi
    xcrun stapler staple "$NAME.app"
    cd ..
fi

echo "Building dmg..."

hdiutil create -size $(($(du -sk "dist/$NAME.app"/ | awk '{print $1}')*175/100))k -fs HFS+ -volname "$NAME" -o "$APP.dmg"
dir="$(echo $(hdiutil attach $APP.dmg | cut -f 3) | cut -f 1)"
mv "dist/$NAME.app" "$dir"
ln -s /Applications "$dir"
hdiutil detach "$dir"
hdiutil convert "$APP.dmg" -format UDZO -o "$APP-$version.dmg"
echo $(shasum -a 256 "$APP-$version.dmg") > "$APP-$version.dmg.sha256"

echo "Cleaning up..."

deactivate
rm -r build dist "$APP.dmg" "$APP@.spec"
if [ ! -d ../venv ]; then
	rm -r venv
fi
mv "$APP-$version.dmg"* ../..
