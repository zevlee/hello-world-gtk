#!/bin/sh

# This script is meant to be run through MinGW

app=hello-world-gtk

echo "Running pyinstaller..."

python3 -OO -m PyInstaller $app.spec

if test ! -f dist/$app/gdbus.exe; then
  cp C:/msys64/mingw32/bin/gdbus.exe dist/$app
fi

cd dist/$app
zip -r $app.zip *
mv $app.zip ../..
cd ../..

echo "Running makensis..."

makensis $app.nsi

for exe in $app*.exe; do
  echo $(sha256sum $exe) > $exe.sha256
done

echo "Cleaning up..."

mv $app*.exe* ../..

rm $app.zip
rm -r build
rm -r dist/*/*
rm -r dist
