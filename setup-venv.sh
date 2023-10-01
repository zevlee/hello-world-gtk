#!/bin/sh

# Run this script to set up a virtual environment for development

echo "Setting up virtual environment..."

python3 -m venv --system-site-packages venv
. venv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt
deactivate

echo "Done"
