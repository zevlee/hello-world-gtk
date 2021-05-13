#!/bin/sh

app=hello-world-gtk
name="Hello World"
version=0.1.0

echo "Running pyinstaller..."

/usr/local/bin/python3 -OO -m PyInstaller "$app.spec" --noconfirm

echo "Preparing app..."

mv dist/* dist/MacOS
mv dist Contents
mkdir Resources
cp "$app.icns" Resources
mv Resources Contents
cp Info.plist Contents
mkdir "$name.app"
mv Contents "$name.app"

echo "Building dmg..."

hdiutil create -size $((($(du -sk "$name.app"/ | awk '{print $1}')+8192)/1024))m -fs HFS+ -volname "$name" -o "$app.dmg"

DIR="$(echo $(hdiutil attach $app.dmg | cut -f 3) | cut -f 1)"

cp -r "$name.app" "$DIR"
ln -s /Applications "$DIR"

hdiutil detach "$DIR"

hdiutil convert "$app.dmg" -format UDZO -o "$app-$version.dmg"

echo $(shasum -a 256 "$app-$version.dmg") > "$app-$version.dmg.sha256"

echo "Cleaning up..."

rm -r build "$name.app" "$app.dmg"

mv "$app-$version.dmg"* ../..
