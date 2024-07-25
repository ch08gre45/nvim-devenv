
-- Interact with system Copy / Paste register
-- Paste
vim.keymap.set("x", "<leader>p", "\"\\\"_dP")
-- Yank into register
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
-- Yank line to register
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- Show / Hide special characters
vim.keymap.set("n", "<F5>", "<Cmd>set list!<CR>", { silent = true })
vim.keymap.set("i", "<F5>", "<C-o><Cmd>set list!<CR>", { silent = true })
vim.keymap.set("c", "<F5>", "<C-c><Cmd>set list!<CR>", { silent = true })

-- Autoclose quotes and brackets
vim.keymap.set("i", "{", "{}<Esc>ha", { silent = true })
vim.keymap.set("i", "(", "()<Esc>ha", { silent = true })
vim.keymap.set("i", "[", "[]<Esc>ha", { silent = true })
vim.keymap.set("i", "\"", "\"\"<Esc>ha", { silent = true })
vim.keymap.set("i", "'", "''<Esc>ha", { silent = true })
vim.keymap.set("i", "`", "``<Esc>ha", { silent = true })

-- [Tab and window utilities]
vim.keymap.set("n", "<leader>q", "<Cmd>q<CR>", { silent = true })
vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>", { silent = true })
vim.keymap.set("n", "<leader>e", "<Cmd>tabnew<CR>", { silent = true })
-- Resize a window
vim.keymap.set("n", "<M-,>", "<c-w>5<")
vim.keymap.set("n", "<M-.>", "<c-w>5>")
vim.keymap.set("n", "<M-t>", "<C-W>+")
vim.keymap.set("n", "<M-s>", "<C-W>-")

-- Developement helpers
vim.keymap.set("n", "<leader><leader>x", "<Cmd>source %<CR>", { silent = true })

-- Open file_name:line_no records by pressing F2 (equivalent to gF)
vim.keymap.set("n", "<F2>", "<Cmd>vertical wincmd F<CR>", { silent = true })

-- Execute shell command and replace it with the output
vim.keymap.set("n", "Q", "!!sh<CR>")

-- Disable search highlight on Esc
vim.keymap.set("n", "<Esc>", "<Cmd>:noh<CR>")

vim.keymap.set("n", "<leader>tr", "<Cmd>NvimTreeToggle<CR>")
