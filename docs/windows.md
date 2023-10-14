### Building on Windows
1. MSYS2 is needed to build on Windows. [Get it from the MSYS2 website.](https://www.msys2.org/)
2. Go to your folder for MSYS2 and run `mingw64.exe`. The following commands will be executed in the console that appears.
3. Install git.
```
pacman -S git
```
4. Clone this repository.
```
git clone https://github.com/zevlee/hello-world-gtk.git
```
5. Enter the `windows` directory.
```
cd hello-world-gtk/windows
```
6. Run `bootstrap.sh` to install any missing dependencies.
```
./bootstrap.sh
```
7. Run `build.sh` with your chosen spec file.
```
./build.sh hello-world-gtk.spec
```
Build Options
Flag                 | Description
:--                  | :--
`-b`                 | Build a portable binary (Without this flag, builds an AppImage)
`-h`                 | Display help dialog

Build Arguments
Flag                 | Description
:--                  | :--
`-e ENV`             | Path to file containing environment variables
`-E VENV`            | Path to directory of python virtual environment
`-r REQUIREMENTS`    | Path to pip requirements file
`-f FILENAME`        | Output filename
`-v VERSION`         | Application version
`-n APPNAME`         | Application name
`-i ICON`            | Path to icon file
`-a AUTHOR`          | Author
`-d DESCRIPTION`     | App description
`-l LICENSE`         | Path to license file
`-o OUTDIR`          | Output directory
`-s SPECFILE`        | Path to spec file

Windows-Specific Build Arguments
Flag                 | Description
:--                  | :--
`-N NSIS`            | Path to NSIS file
