#!/bin/bash
echo "Removing old build folders.."
rm -rf build dist gpucv.egg-info
echo "Building wheels...."
python3.7 setup.py bdist_wheel
echo "Uninstalling old installation.."
pip3 uninstall gpucv
echo "Installing new wheel.."
pip3 install dist/*.whl
echo "Running tests..."
python3 test.py

