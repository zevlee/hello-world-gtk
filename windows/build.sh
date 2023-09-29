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

# Function to make installer
make_installer() {
	echo "Running pyinstaller..."
	python3 -OO -m PyInstaller ${FILENAME}.spec
	echo "Preparing app..."
	cd dist/${FILENAME}
	zip -r ${FILENAME}.zip *
	mv ${FILENAME}.zip ../..
	cd ../..
	echo ${APPNAME} > build/APPNAME
	echo ${FILENAME} > build/FILENAME
	echo ${AUTHOR} > build/AUTHOR
	echo ${DESCRIPTION} > build/DESCRIPTION
	echo $(du -sk dist/${FILENAME} | cut -f 1) > build/INSTALLSIZE
	echo $(uname -m) > build/ARCH
	echo "Running makensis..."
	makensis ${FILENAME}.nsi
	PACKAGE=${FILENAME}-${VERSION}-$(uname -m).exe
	echo $(sha256sum ${PACKAGE}) > ${PACKAGE}.sha256
}

# Function to make portable binary
make_binary() {
	echo "Running pyinstaller..."
	python3 -OO -m PyInstaller ${FILENAME}-portable.spec
	echo "Preparing app..."
	PACKAGE=${FILENAME}-${VERSION}-$(uname -m)-portable.exe
	mv dist/* ./${PACKAGE}
	echo $(sha256sum ${PACKAGE}) > ${PACKAGE}.sha256
}

# Function to clean up build artifacts
clean_up() {
	echo "Cleaning up..."
	deactivate
	mv ${PACKAGE}* ../..
	rm -rf build ${FILENAME}.zip dist venv
}

# Function to display help
show_help() {
	echo "Build a Windows executable file, either an installer or portable binary"
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
	make_installer
	clean_up
}

main "$@"
