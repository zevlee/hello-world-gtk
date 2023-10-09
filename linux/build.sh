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

# Function to make desktop file
make_desktop() {
	KEYS=(
		"Type"
		"Version"
		"Name"
		"GenericName"
		"NoDisplay"
		"Comment"
		"Icon"
		"Hidden"
		"OnlyShowIn"
		"DBusActivatable"
		"TryExec"
		"Exec"
		"Path"
		"Terminal"
		"Actions"
		"MimeType"
		"Categories"
		"Implements"
		"Keywords"
		"StartupNotify"
		"StartupWMClass"
		"URL"
		"PrefersNonDefaultGPU"
		"SingleMainWindow"
	)
	echo "[Desktop Entry]" > "build/${FILENAME}.desktop"
	for KEY in ${KEYS[@]}; do
		VALUE="${!KEY}"
		if [ ! -z "${VALUE}" ]; then
			echo "${KEY}=${VALUE}" >> "build/${FILENAME}.desktop"
		fi
	done
	# Add application version if set
	if [ ! -z ${VERSION} ]; then
		echo "X-AppImage-Version=${VERSION}" >> "build/${FILENAME}.desktop"
	fi
	# Add default values
	if [ -z "${Type}" ]; then
		echo "Type=Application" >> "build/${FILENAME}.desktop"
	fi
	if [ -z "${Name}" ]; then
		echo "Name=${APPNAME}" >> "build/${FILENAME}.desktop"
	fi
	if [ -z "${Exec}" ]; then
		echo "Exec=${FILENAME}" >> "build/${FILENAME}.desktop"
	fi
}

# Function to make AppImage
make_appimage() {
	echo "Running pyinstaller..."
	python3 -OO -m PyInstaller "${SPECFILE}" --noconfirm
	echo "Preparing app..."
	mv "dist/${FILENAME}/${FILENAME}" "dist/${FILENAME}/AppRun"
	make_desktop
	mv "build/${FILENAME}.desktop" "dist/${FILENAME}/${FILENAME}.desktop"
	if [ ! -z "${ICON}" ]; then cp "${ICON}" "dist/${FILENAME}/$(basename ${ICON})"; fi
	wget -P build "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-$(uname -m).AppImage"
	chmod +x "build/appimagetool-$(uname -m).AppImage"
	echo "Running appimagetool..."
	ARCH=$(uname -m) "build/appimagetool-$(uname -m).AppImage" "dist/${FILENAME}"
	PACKAGE="${FILENAME}-${VERSION}-$(uname -m).AppImage"
	mv *".AppImage" "${PACKAGE}"
	echo $(shasum -a 256 "${PACKAGE}") > "${PACKAGE}.sha256"
}

# Function to make portable binary
make_binary() {
	echo "Running pyinstaller..."
	python3 -OO -m PyInstaller "${SPECFILE}" --noconfirm
	echo "Preparing app..."
	PACKAGE="${FILENAME}-${VERSION}-$(uname -m)-linux.tar.gz"
	if [ ! -z "${LICENSE}" ]; then
		tar -czf "${PACKAGE}" -C dist "${FILENAME}" -C .. "${LICENSE}"
	else
		tar -czf "${PACKAGE}" -C dist "${FILENAME}"
	fi
	echo $(shasum -a 256 "${PACKAGE}") > "${PACKAGE}.sha256"
}

# Function to clean up build artifacts and move package files
clean_up() {
	echo "Cleaning up..."
	deactivate
	rm -rf build dist venv
	mv "${PACKAGE}"* "${OUTDIR}" 2> /dev/null
}

# Function to display help
show_help() {
	echo "Build a Linux executable file, either an AppImage or portable binary"
	echo
	echo "Syntax:"
	echo "./build.sh [Options] [Arguments] SPECFILE"
	echo
	echo "Options:"
	echo "-b                  Build a portable binary"
	echo "-h                  Display help dialog"
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
	echo "Note:"
	echo "Setting SPECFILE as a positional argument will take precedence over"
	echo "its equivalent in the environment file and preceding arguments"
	echo
}

# Main function
main() {
	while getopts "e:E:r:f:v:n:i:a:d:l:o:s:bh" OPTION; do
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
	if [ ! -z ${BINARY} ]; then make_binary; else make_appimage; fi
	clean_up
}

main "$@"
