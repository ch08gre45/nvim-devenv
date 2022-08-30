#!/bin/bash

THIS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

mkdir -p ~/.config/nvim/lua
mkdir -p ~/.config/nvim/plugin
# Remove old config files
rm -rf ~/.config/nvim/lua/* 
rm -rf ~/.config/nvim/plugin/* 

# Update new lua configs
cp -rf ${THIS_DIR}/lua/* ~/.config/nvim/lua/
cp -rf ${THIS_DIR}/plugin/* ~/.config/nvim/plugin/

# Update init.vim and .vimrc
cp -f ${THIS_DIR}/init.vim ~/.config/nvim/init.vim
cp -f ${THIS_DIR}/vimrc ~/.vimrc
