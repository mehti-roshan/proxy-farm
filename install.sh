#!/bin/bash

mkdir -p install_files && cd install_files

echo "Installing haproxy..."
sudo apt install haproxy

echo "Installing 3proxy..."
git clone https://github.com/z3apa3a/3proxy
cd 3proxy
ln -s Makefile.Linux Makefile
make
sudo make install

cd ..