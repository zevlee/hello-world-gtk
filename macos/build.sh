#!/bin/sh

app=hello-world-gtk
name="Hello World"

version=$(cat ../VERSION)

echo "Preparing app..."

cp "$app.spec" "$app@.spec"
sed -i '' "s/'VERSION'/'$version'/g" "$app@.spec"

echo "Running pyinstaller..."

/usr/local/bin/python3 -OO -m PyInstaller "$app@.spec" --noconfirm

echo "Building dmg..."

hdiutil create -size $(($(du -sk "dist/$name.app"/ | awk '{print $1}')*175/100))k -fs HFS+ -volname "$name" -o "$app.dmg"

DIR="$(echo $(hdiutil attach $app.dmg | cut -f 3) | cut -f 1)"

cp -r "dist/$name.app" "$DIR"
ln -s /Applications "$DIR"

hdiutil detach "$DIR"

hdiutil convert "$app.dmg" -format UDZO -o "$app-$version.dmg"

echo $(shasum -a 256 "$app-$version.dmg") > "$app-$version.dmg.sha256"

echo "Cleaning up..."

rm -r build dist "$app.dmg" "$app@.spec"

mv "$app-$version.dmg"* ../..
