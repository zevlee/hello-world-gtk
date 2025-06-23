# Hello World GTK
Hello World GTK is an easily configurable build system for distributing
Python-based GTK applications. This is an example repository for
[PyDeployment](https://github.com/pydeployment/pydeployment), which is used to
easily build applications for Windows, macOS, and Linux.

Check out the workflow file to get an idea of how to use GitHub workflows to
automate creating releases and building binaries.

## Examples
The following is a non-exhaustive list of projects that incorporate parts of
this repository in their build systems.

* [GTK LLM Chat](https://github.com/icarito/gtk-llm-chat)
* [Waydroid Helper](https://github.com/ayasa520/waydroid-helper)
* [Fightsticker](https://github.com/zevlee/fightsticker)
* [Passphraser](https://github.com/zevlee/passphraser)

## Code Signing and Notarization for macOS Builds
On macOS, applications must be code signed and notarized in order for users to
run them without bypassing Gatekeeper. You will need an active Apple Developer
account in order to generate and use the necessary certificate to code sign
your application.

To enable code signing and notarization for macOS builds, you will need to
uncomment the relevant lines in the `build-macos.yml` and
`build-macos-intel.yml` workflow files and add several repository secrets.
These secrets can be added at
`https://github.com/<user>/<repo>/settings/secrets/actions`.

The following secrets are needed.

| Name | Content |
| :-- | :-- |
| MACOS_CERTIFICATE | Developer ID Application certificate exported from the Keychain Access app and encoded in base64 |
| MACOS_CERTIFICATE_NAME | Name of the Developer ID Application certificate. Comes in the form `Developer ID Application: Name Here (TEAMIDHERE)` |
| MACOS_CERTIFICATE_PWD | The password of the exported certificate |
| MACOS_CI_KEYCHAIN_PWD | Randomly generated password |
| MACOS_NOTARIZATION_APPLE_ID | Apple ID of the Apple Developer Account |
| MACOS_NOTARIZATION_PWD | A generated app-specific password |
| MACOS_NOTARIZATION_TEAM_ID | Team ID of the Apple Developer Account |
