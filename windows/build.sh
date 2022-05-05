#!/bin/sh

# This script is meant to be run through MinGW

APP=hello-world-gtk

echo "Running pyinstaller..."

python3 -OO -m PyInstaller $APP.spec

if test ! -f dist/$APP/gdbus.exe; then
    cp C:/msys64/mingw32/bin/gdbus.exe dist/$APP
fi

cd dist/$APP
zip -r $APP.zip *
mv $APP.zip ../..
cd ../..

echo "Running makensis..."

makensis $APP.nsi

for exe in $APP*.exe; do
    echo $(sha256sum $exe) > $exe.sha256
done

echo "Cleaning up..."

mv $APP*.exe* ../..

rm $APP.zip
rm -r build
rm -r dist/*/*
rm -r dist
