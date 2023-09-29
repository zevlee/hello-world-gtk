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

# Function to make AppImage
make_appimage() {
	echo "Running pyinstaller..."
	python3 -OO -m PyInstaller ${FILENAME}.spec --noconfirm
	echo "Preparing app..."
	mv dist/${FILENAME}/${FILENAME} dist/${FILENAME}/AppRun
	sed -i "s/X-AppImage-Version=VERSION/X-AppImage-Version="${VERSION}"/g" dist/${FILENAME}/_internal/${FILENAME}.desktop
	ln -s _internal/${FILENAME}.desktop dist/${FILENAME}/${FILENAME}.desktop
	ln -s _internal/${ICON} dist/${FILENAME}/${ICON}
	wget https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-$(uname -m).AppImage
	chmod +x appimagetool-$(uname -m).AppImage
	echo "Running appimagetool..."
	ARCH=$(uname -m) ./appimagetool-$(uname -m).AppImage dist/${FILENAME}
	rm appimagetool-$(uname -m).AppImage
	PACKAGE=${FILENAME}-${VERSION}-$(uname -m).AppImage
	mv *.AppImage ${PACKAGE}
	echo $(sha256sum ${PACKAGE}) > ${PACKAGE}.sha256
}

# Function to make portable binary
make_binary() {
	echo "Running pyinstaller..."
	python3 -OO -m PyInstaller ${FILENAME}-portable.spec --noconfirm
	echo "Preparing app..."
	PACKAGE=${FILENAME}-${VERSION}-$(uname -m)-portable.tar.gz
	tar -czf ${PACKAGE} -C dist ${FILENAME} -C ../.. LICENSE
	echo $(sha256sum ${PACKAGE}) > ${PACKAGE}.sha256
}

# Function to clean up build artifacts
clean_up() {
	echo "Cleaning up..."
	deactivate
	rm -rf build dist venv
	mv ${PACKAGE}* ../..
}

# Function to display help
show_help() {
	echo "Build a Linux executable file, either an AppImage or portable binary"
	echo
	echo "Syntax:"
	echo "./build.sh [-b|h]"
	echo
	echo "Options:"
	echo "-b          Build a portable binary"
	echo "-h          Display help dialog"
	echo
}

# Main function
main() {
	. ../INFO
	VERSION=$(cat ../VERSION)
	while getopts "bh" OPTION; do
		case ${OPTION} in
			b)
				setup_venv
				make_binary
				clean_up
				exit 0
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
	make_appimage
	clean_up
}

main "$@"
