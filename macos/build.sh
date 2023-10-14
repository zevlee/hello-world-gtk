#!/bin/sh

# Function to set up virtual environment
setup_venv() {
	if [ -z "${VENV}" ]; then
		echo "Setting up virtual environment..."
		python3 -m venv --system-site-packages venv
		. venv/bin/activate
		python3 -m pip install --upgrade pip
		if [ ! -z "${REQUIREMENTS}" ]; then
			python3 -m pip install -r "${REQUIREMENTS}"
		fi
	else
		. "${VENV}"/bin/activate
	fi
}

# Function to make app bundle
make_app() {
	echo "Preparing app..."
	VERSION=$(cat ../VERSION)
	cp "${SPECFILE}" build.spec
	sed -i '' "s/'VERSION'/'${VERSION}'/g" build.spec
	if [ ! -z "${CERT}" ]; then
	    sed -i '' \
	    	"s/codesign_identity=''/codesign_identity='${CERT}'/g" \
	    	build.spec
	fi
	echo "Running pyinstaller..."
	python3 -OO -m PyInstaller build.spec --noconfirm
}

# Function to notarize app bundle
notarize_app() {
	echo "Notarizing app..."
	cd dist
	ZIP="${FILENAME}-${VERSION}-$(uname -m).zip"
	ditto -ck --sequesterRsrc --keepParent "${APPNAME}.app" "${ZIP}"
	if [ ! -z "${KEYC}" ]; then
		xcrun notarytool submit "${ZIP}" \
			--keychain-profile "${KEYC}" \
			--wait
	else
		xcrun notarytool submit "${ZIP}" \
			--apple-id "${APID}" \
			--team-id "${TMID}" \
			--password "${PASS}" \
			--wait
	fi
	xcrun stapler staple "${APPNAME}.app"
	cd ..
}

# Function to build DMG
build_dmg() {
	echo "Building DMG..."
	DMG=build/"${FILENAME}.dmg"
	hdiutil create -size \
		$(($(du -sk "dist/${APPNAME}.app"/ | awk '{print $1}')*175/100))k \
		-fs HFS+ -volname "${APPNAME}" -o "${DMG}"
	DIR="$(echo $(hdiutil attach ${DMG} | cut -f 3) | cut -f 1)"
	mv "dist/${APPNAME}.app" "${DIR}"
	ln -s /Applications "${DIR}"
	cp "${ICON}" "${DIR}"/.VolumeIcon.icns
	SetFile -c icnC "${DIR}"/.VolumeIcon.icns
	SetFile -a C "${DIR}"
	hdiutil detach "${DIR}"
	PACKAGE="${FILENAME}-${VERSION}-$(uname -m).dmg"
	hdiutil convert "${DMG}" -format UDZO -o "${PACKAGE}"
	echo $(shasum -a 256 "${PACKAGE}") > "${PACKAGE}.sha256"
}

# Function to make portable binary
make_binary() {
	echo "Running pyinstaller..."
	python3 -OO -m PyInstaller "${SPECFILE}" --noconfirm
	echo "Preparing app..."
	PACKAGE="${FILENAME}-${VERSION}-$(uname -m)-macos.tar.gz"
	if [ ! -z "${LICENSE}" ]; then
		tar -czf "${PACKAGE}" -C dist "${FILENAME}" -C .. "${LICENSE}"
	else
		tar -czf "${PACKAGE}" -C dist "${FILENAME}"
	fi
	echo $(shasum -a 256 "${PACKAGE}") > "${PACKAGE}.sha256"
}

# Function to clean up build artifacts
clean_up() {
	echo "Cleaning up..."
	deactivate
	rm -rf build dist venv build.spec
	mv "${PACKAGE}"* "${OUTDIR}" 2> /dev/null
}

# Function to display help
show_help() {
	echo "Build a macOS app bundled in a DMG"
	echo
	echo "Syntax:"
	echo "./build.sh [Options] [Arguments] SPECFILE"
	echo
	echo "Options:"
	echo "-b          Build a portable binary"
	echo "-h          Display help dialog"
	echo
	echo "Arguments:"
	echo "-e ENV              Path to file containing environment variables"
	echo "-E VENV             Path to directory of python virtual environment"
	echo "-r REQUIREMENTS     Path to pip requirements file"
	echo "-f FILENAME         Output filename"
	echo "-v VERSION          Application version"
	echo "-n APPNAME          Application name"
	echo "-i ICON             Path to icon file"
	echo "-a AUTHOR           Author"
	echo "-d DESCRIPTION      App description"
	echo "-l LICENSE          Path to license file"
	echo "-o OUTDIR           Output directory"
	echo "-s SPECFILE         Path to spec file"
	echo
	echo "macOS-Specific Arguments:"
	echo "-C CERT     Common Name of Certificate"
	echo "-K KEYC     Name of stored Keychain Profile"
	echo "-A APID     Apple ID"
	echo "-T TMID     Team ID"
	echo "-P PASS     App-Specific Password"
	echo
	echo "Usage:"
	echo "Enable codesigning by adding the certificate CERT"
	echo "./build.sh -C 'Developer ID Application: Name Here (TEAMIDHERE)' \\"
	echo "    specfile.spec"
	echo
	echo "Additionally enable notarization by adding the name of a stored"
	echo "keychain profile KEYC"
	echo "./build.sh -C 'Developer ID Application: Name Here (TEAMIDHERE)' \\"
	echo "    -K 'keychain-profile-here' \\"
	echo "    specfile.spec"
	echo
	echo "Alternatively, enable notarization by adding Apple ID APID, Team"
	echo "ID TMID, and App-Specific Password PASS"
	echo "./build.sh -C 'Developer ID Application: Name Here (TEAMIDHERE)' \\"
	echo "    -A 'appleid@here.com' \\"
	echo "    -T 'TEAMIDHERE' \\"
	echo "    -P 'pass-word-goes-here' \\"
	echo "    specfile.spec"
	echo
}

# Main function
main() {
	while getopts "e:E:r:f:v:n:i:a:d:l:o:s:C:K:A:T:P:bh" OPTION; do
		case ${OPTION} in
			b) BINARY=true;;
			h) show_help; exit 0;;
			e) . "${OPTARG}"; ENV=true;;
			E) VENV="${OPTARG}";;
			r) REQUIREMENTS="${OPTARG}";;
			f) FILENAME="${OPTARG}";;
			v) VERSION="${OPTARG}";;
			n) APPNAME="${OPTARG}";;
			i) ICON="${OPTARG}";;
			a) AUTHOR="${OPTARG}";;
			d) DESCRIPTION="${OPTARG}";;
			l) LICENSE="${OPTARG}";;
			o) OUTDIR="${OPTARG}";;
			s) SPECFILE="${OPTARG}";;
			C) CERT="${OPTARG}";;
			K) KEYC="${OPTARG}";;
			A) APID="${OPTARG}";;
			T) TMID="${OPTARG}";;
			P) PASS="${OPTARG}";;
			?) exit 1;;
		esac
	done
	# Set SPECFILE if set as a positional argument
	if [ ! -z "${@:$OPTIND:1}" ]; then SPECFILE="${@:$OPTIND:1}"; fi
	# Exit if there still is no spec file
	if [ -z "${SPECFILE}" ]; then
		echo "${0}: PyInstaller spec file not set"
		exit 1
	fi
	# Set default values
	if [ -z "${ENV}" ]; then . ./.env 2> /dev/null; fi
	if [ -z "${FILENAME}" ]; then FILENAME="${SPECFILE%.spec}"; fi
	if [ -z "${APPNAME}" ]; then APPNAME="${SPECFILE%.spec}"; fi
	if [ -z "${OUTDIR}" ]; then OUTDIR=.; fi
	# Build package
	setup_venv
	if [ ! -z ${BINARY} ]; then
		make_binary
	else
		make_app
		if [ ! -z "${CERT}" ] && { [ ! -z "${KEYC}" ] || \
				{ [ ! -z "${APID}" ] && [ ! -z "${TMID}" ] && \
				[ ! -z "${PASS}" ]; }; }; then
			notarize_app
		fi
		build_dmg
	fi
	clean_up
}

main "$@"
