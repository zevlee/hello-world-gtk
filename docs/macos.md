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
Enable code signing by adding the Common Name of the certificate as the first argument. Without this, adhoc signing will be used.
```
./build.sh "Developer ID Application: Name Here (TEAMIDHERE)"
```
Enable notarization by also adding the name of a stored keychain profile.
```
./build.sh "Developer ID Application: Name Here (TEAMIDHERE)" "keychain-profile-here"
```
Notarization can alternatively be enabled by adding Apple ID, Team ID, and an app-specific password as subsequent arguments.
```
./build.sh "Developer ID Application: Name Here (TEAMIDHERE)" "appleid@here.com" "TEAMIDHERE" "pass-word-goes-here"
```
