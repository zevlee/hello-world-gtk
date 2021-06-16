# Hello World GTK
This repository is an easily configurable build system for distributing Python-based GTK applications. First, [PyInstaller](https://github.com/pyinstaller/pyinstaller) is used to assemble the application directory. Then, a packaging program is used to bundle everything into a self-contained application.

* On Windows, [NSIS](https://nsis.sourceforge.io) is used.
* On macOS, the built-in hdiutil is used.
* On Linux, [AppImageKit](https://github.com/AppImage/AppImageKit) is used.

The releases section contains the result of using this repo as-is.

Presently, GTK3 is supported. The repo will be updated to support GTK4 once there is better support for Windows and macOS. 

### Building on Windows
1. MSYS2 is needed to build on Windows. [Get it from the MSYS2 website.](https://www.msys2.org/)
2. Download a copy of this repository, then extract it to your home folder for MSYS2 (Usually ``C:\msys64\home\<user>``).
3. Go to your folder for MSYS2 and run ``mingw32.exe``. The following commands will be executed in the console that appears.
4. Enter the ``windows`` directory of the extracted repository.
```
cd hello-world-gtk/windows
```
5. Run ``bootstrap.sh`` to install any missing dependencies.
```
chmod +x bootstrap.sh && ./bootstrap.sh
```
6. Run ``build.sh``.
```
chmod +x build.sh && ./build.sh
```

### Building on macOS
1. Brew is needed to install PyGObject. [Get it from the brew website.](https://brew.sh)
2. Clone this repository.
```
git clone https://github.com/zevlee/hello-world-gtk.git
```
3. Enter the ``macos`` directory.
```
cd hello-world-gtk/macos
```
4. Run ``bootstrap.sh`` to install any missing dependencies.
```
chmod +x bootstrap.sh && ./bootstrap.sh
```
5. Run ``build.sh``.
```
chmod +x build.sh && ./build.sh
```

### Building on Linux
1. Ensure PyGObject is installed.
2. Clone this repository
```
git clone https://github.com/zevlee/hello-world-gtk.git
```
3. Enter the ``linux`` directory
```
cd hello-world-gtk/linux
```
4. Run ``bootstrap.sh`` to install pyinstaller via pip if you haven't already.
```
chmod +x bootstrap.sh && ./bootstrap.sh
```
5. Run ``build.sh``.
```
chmod +x build.sh && ./build.sh
```
