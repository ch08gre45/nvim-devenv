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

## Font

With the addition of nvim-tree plugin, a patched font is required to display symbols. This requires some configurations steps.

1. Go [here](https://www.nerdfonts.com/font-downloads)
2. Pick a font and download it
3. Extract the font to `~/.local/share/fonts/`
4. Configure your terminal to use it
