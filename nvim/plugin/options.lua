local opt = vim.opt

opt.background = "dark"

opt.exrc = true
opt.secure = true
-- Search down into subfolders
-- Provide tab completion for file related tasks   
table.insert(opt.path, "**")
-- Show (partial) command in status line
opt.showcmd = true
-- Show matching brackets
opt.showmatch = true
-- Enable case insensitive matching
opt.ignorecase = true
-- Enable smart case matching
opt.smartcase = true
-- Incremental search
opt.incsearch = true
-- Enable mouse usage in all modes
opt.mouse = "a"

opt.number = true
opt.relativenumber = true

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexp()"
opt.foldlevel = 99

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
-- Enable global statusline, shows for last buffer
opt.laststatus = 3

opt.splitright = true

opt.listchars = "trail:·,lead:·,precedes:«,extends:»,eol:↲,tab:▸\\"
