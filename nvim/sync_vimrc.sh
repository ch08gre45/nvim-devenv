#!/bin/bash

THIS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
mkdir -p ~/.config/nvim/lua
cp -rf ${THIS_DIR}/lua/* ~/.config/nvim/lua/
cp -f ${THIS_DIR}/init.vim ~/.config/nvim/init.vim
cp -f ${THIS_DIR}/vimrc ~/.vimrc
