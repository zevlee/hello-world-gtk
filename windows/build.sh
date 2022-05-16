#!/bin/sh

# This script is meant to be run through MinGW

APP=hello-world-gtk

echo "Setting up virtual environment..."

python3 -m venv --system-site-packages venv
. venv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install -r ../requirements.txt

echo "Running pyinstaller..."

python3 -OO -m PyInstaller $APP.spec

echo "Preparing app..."

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

deactivate
mv $APP*.exe* ../..
rm $APP.zip
rm -r build
rm -r dist/*/*
rm -r dist
rm -r venv
