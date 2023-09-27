#!/bin/sh

# Function to set up virtual environment
setup_venv() {
	if [ ! -d ../venv ]; then
		echo "Setting up virtual environment..."
		python3 -m venv --system-site-packages venv
		. venv/bin/activate
		python3 -m pip install --upgrade pip
		python3 -m pip install -r ../requirements.txt
	else
		. ../venv/bin/activate
	fi
}

# Function to make app bundle
make_app() {
	echo "Preparing app..."
	VERSION=$(cat ../VERSION)
	cp "$APP.spec" "$APP@.spec"
	sed -i '' "s/'VERSION'/'$VERSION'/g" "$APP@.spec"
	if [ ! -z "$CERT" ]; then
	    sed -i '' "s/codesign_identity=''/codesign_identity='$CERT'/g" "$APP@.spec"
	fi
	echo "Running pyinstaller..."
	python3 -OO -m PyInstaller "$APP@.spec" --noconfirm
}

# Function to notarize app bundle
notarize_app() {
	echo "Notarizing app..."
	cd dist
	ZIP="$APP-$VERSION-$(uname -m).zip"
	ditto -ck --sequesterRsrc --keepParent "$NAME.app" "$ZIP"
	if [ ! -z "$KEYC" ]; then
		xcrun notarytool submit "$ZIP" --keychain-profile "$KEYC" --wait
	else
		xcrun notarytool submit "$ZIP" --apple-id "$APID" --team-id "$TMID" --password "$PASS" --wait
	fi
	xcrun stapler staple "$NAME.app"
	cd ..
}

# Function to build DMG
build_dmg() {
	echo "Building DMG..."
	hdiutil create -size $(($(du -sk "dist/$NAME.app"/ | awk '{print $1}')*175/100))k -fs HFS+ -volname "$NAME" -o "$APP.dmg"
	DIR="$(echo $(hdiutil attach $APP.dmg | cut -f 3) | cut -f 1)"
	mv "dist/$NAME.app" "$DIR"
	ln -s /Applications "$DIR"
	hdiutil detach "$DIR"
	PACKAGE="$APP-$VERSION-$(uname -m).dmg"
	hdiutil convert "$APP.dmg" -format UDZO -o "$PACKAGE"
	echo $(shasum -a 256 "$PACKAGE") > "$PACKAGE.sha256"
}

# Function to clean up build artifacts
clean_up() {
	echo "Cleaning up..."
	deactivate
	rm -rf build dist "$APP.dmg" "$APP@.spec" venv
	mv "$APP-$VERSION-$(uname -m).dmg"* ../..
}

# Function to display help
show_help() {
	echo "Build a macOS app bundled in a DMG"
	echo
	echo "Syntax:"
	echo "./build.sh [-h] [-c CERT] [[-k KEYC]|[-a APID] [-t TMID] [-p PASS]]"
	echo
	echo "Options:"
	echo "-h          Display help dialog"
	echo
	echo "Arguments:"
	echo "-c CERT     Common Name of Certificate"
	echo "-k KEYC     Name of stored Keychain Profile"
	echo "-a APID     Apple ID"
	echo "-t TMID     Team ID"
	echo "-p PASS     App-Specific Password"
	echo
	echo "Usage:"
	echo "Enable codesigning by adding the certificate CERT"
	echo "./build.sh -c 'Developer ID Application: Name Here (TEAMIDHERE)'"
	echo
	echo "Additionally enable notarization by adding the name of a stored"
	echo "keychain profile KEYC"
	echo "./build.sh -c 'Developer ID Application: Name Here (TEAMIDHERE) \\"
	echo "    -k 'keychain-profile-here'"
	echo
	echo "Alternatively, enable notarization by adding Apple ID APID, Team"
	echo "ID TMID, and App-Specific Password PASS"
	echo "./build.sh -c 'Developer ID Application: Name Here (TEAMIDHERE) \\"
	echo "    -a 'appleid@here.com' \\"
	echo "    -t 'TEAMIDHERE' \\"
	echo "    -p 'pass-word-goes-here'"
	echo
}

# Main function
main() {
	. ../INFO
	VERSION=$(cat ../VERSION)
	while getopts "c:k:a:t:p:h" OPTION; do
		case $OPTION in
			c)
				CERT="$OPTARG"
				;;
			k)
				KEYC="$OPTARG"
				;;
			a)
				APID="$OPTARG"
				;;
			t)
				TMID="$OPTARG"
				;;
			p)
				PASS="$OPTARG"
				;;
			h)
				show_help
				exit 0
				;;
			?)
				exit 1
				;;
		esac
	done
	setup_venv
	make_app
	if [ ! -z "$CERT" ] && { [ ! -z "$KEYC" ] || { [ ! -z "$APID" ] && \
			[ ! -z "$TMID" ] && [ ! -z "$PASS" ]; }; }; then
		notarize_app
	fi
	build_dmg
	clean_up
}

main "$@"
