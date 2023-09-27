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
5. Run `build.sh`.
```
./build.sh
```
Build Options
Flag | Description
:-- | :--
`-p` | Build a portable binary (Without this flag, builds an AppImage)
`-h` | Display help dialog
