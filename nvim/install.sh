#!/bin/bash

# Where everything is git cloned
TOOLS_INSTALL_PATH=~/Code/tools
# Ensure the install path exists
mkdir -p $TOOLS_INSTALL_PATH

THIS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# get neovim from github and build and compile latest stable

echo "Using ${TOOLS_INSTALL_PATH} to clone repositories"

echo "Installing NEOVIM"
cd $TOOLS_INSTALL_PATH
git clone https://github.com/neovim/neovim
cd neovim

# Install dependencies to build neovim from source
sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

echo "Installing FZF"
cd $TOOLS_INSTALL_PATH
git clone --depth 1 https://github.com/junegunn/fzf.git
cd fzf
./install

echo "Installing ripgrep"
sudo apt install -o Dpkg::Options::="--force-overwrite" bat ripgrep

echo "Installing .vimrc and configs"
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/lua
mkdir -p ~/.config/nvim/plugin
mkdir -p ~/.config/nvim/after
rm -rf ~/.config/nvim/lua/* 
rm -rf ~/.config/nvim/plugin/* 
rm -rf ~/.config/nvim/after/* 
cp -rf ${THIS_DIR}/lua/* ~/.config/nvim/lua/
cp -rf ${THIS_DIR}/plugin/* ~/.config/nvim/plugin/
cp -rf ${THIS_DIR}/after/* ~/.config/nvim/after/
cp ${THIS_DIR}/init.vim ~/.config/nvim/init.vim
cp ${THIS_DIR}/vimrc ~/.vimrc
