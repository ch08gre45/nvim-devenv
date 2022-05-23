#!/bin/bash

THIS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

mkdir -p ~/.config/nvim/lua
# Remove old lua config files
rm -rf ~/.config/nvim/lua/* 
# Update new lua configs
cp -rf ${THIS_DIR}/lua/* ~/.config/nvim/lua/
# Update init.vim and .vimrc
cp -f ${THIS_DIR}/init.vim ~/.config/nvim/init.vim
cp -f ${THIS_DIR}/vimrc ~/.vimrc
