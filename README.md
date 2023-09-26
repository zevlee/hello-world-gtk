# Hello World GTK
This repository is an easily configurable build system for distributing Python-based GTK applications. First, [PyInstaller](https://github.com/pyinstaller/pyinstaller) is used to assemble the application directory. Then, a packaging program is used to bundle everything into a self-contained application.

* On Windows, [NSIS](https://nsis.sourceforge.io) is used.
* On macOS, the built-in hdiutil is used.
* On Linux, [AppImageKit](https://github.com/AppImage/AppImageKit) is used.

The releases section contains the result of using this repo as-is.

GTK3 and GTK4 are fully supported.

## [Documentation](/docs/README.md)

[Building on Windows](/docs/windows.md)

[Building on macOS](/docs/macos.md)

[Building on Linux](/docs/linux.md)
