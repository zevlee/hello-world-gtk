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
5. Run `build.sh`.
```
./build.sh
```
Build Options
Flag | Description
:-- | :--
`-b` | Build a portable binary (Without this flag, builds a dmg with an app bundle)
`-h` | Display help dialog

Build Arguments
Flag | Description
:-- | :--
`-c CERT` | Common Name of Certificate
`-k KEYC` | Name of stored Keychain Profile
`-a APID` | Apple ID
`-t TMID` | Team ID
`-p PASS` | App-Specific Password

Enable code signing by adding the Common Name of the certificate as the first argument. Without this, adhoc signing will be used.
```
./build.sh -c "Developer ID Application: Name Here (TEAMIDHERE)"
```
Enable notarization by also adding the name of a stored keychain profile.
```
./build.sh -c "Developer ID Application: Name Here (TEAMIDHERE)" \
	-k "keychain-profile-here"
```
Alternatively, enable notarization by adding Apple ID, Team ID, and an app-specific password as arguments.
```
./build.sh -c "Developer ID Application: Name Here (TEAMIDHERE)" \
	-a "appleid@here.com" \
	-t "TEAMIDHERE" \
	-p "pass-word-goes-here"
```
