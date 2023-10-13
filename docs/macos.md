### Building on macOS
1. Homebrew is needed to install PyGObject. [Get it from the Homebrew website.](https://brew.sh)
2. Clone this repository.
```
git clone https://github.com/zevlee/hello-world-gtk.git
```
3. Enter the `macos` directory.
```
cd hello-world-gtk/macos
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
Flag | Description
:-- | :--
`-b` | Build a portable binary (Without this flag, builds a DMG containing an app bundle)
`-h` | Display help dialog

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

macOS-Specific Build Arguments
Flag | Description
:-- | :--
`-C CERT` | Common Name of Certificate
`-K KEYC` | Name of stored Keychain Profile
`-A APID` | Apple ID
`-T TMID` | Team ID
`-P PASS` | App-Specific Password

Enable code signing by adding the Common Name of the certificate as the first argument. Without this, adhoc signing will be used.
```
./build.sh -C "Developer ID Application: Name Here (TEAMIDHERE)" \
    hello-world-gtk.spec
```
Enable notarization by also adding the name of a stored keychain profile.
```
./build.sh -C "Developer ID Application: Name Here (TEAMIDHERE)" \
	-K "keychain-profile-here" \
	hello-world-gtk.spec
```
Alternatively, enable notarization by adding Apple ID, Team ID, and an app-specific password as arguments.
```
./build.sh -C "Developer ID Application: Name Here (TEAMIDHERE)" \
	-A "appleid@here.com" \
	-T "TEAMIDHERE" \
	-P "pass-word-goes-here" \
	hello-world-gtk.spec
```
