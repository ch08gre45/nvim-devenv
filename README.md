# nvim-devenv

This repository automates most of the manual steps of installing NEOVIM on a new machine.
The install script is not unattended, since it prompts for sudo privileges during neovim install and at the end prompts for user preferences durin fzf install script

Script clones nvim and fzf inside `~/Code/tools` which will be created if it does not exist.

The script installs:
- [Neovim](https://github.com/neovim/neovim)
- [FZF](https://github.com/junegunn/fzf)
- custom .vimrc
- [Vim-Plug](https://github.com/junegunn/vim-plug) via .vimrc autoinstall
- [Nightfox](https://github.com/EdenEast/nightfox.nvim) theme, sets nordfox colorscheme

Everything is built from source.
