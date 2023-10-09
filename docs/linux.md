### Building on Linux
1. Ensure PyGObject is installed.
2. Clone this repository.
```
git clone https://github.com/zevlee/hello-world-gtk.git
```
3. Enter the `linux` directory.
```
cd hello-world-gtk/linux
```
4. Run `bootstrap.sh` to install any missing dependencies.
```
./bootstrap.sh
```
5. Run `build.sh` with your chosen spec file.
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
 