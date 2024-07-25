if vim.uv.fs_stat("./.nvimrc") then
    print("Found custom .nvimrc")
    vim.cmd("source ./.nvimrc")
end

if vim.uv.fs_stat("./.nvim.lua") then
    print("Found custom .nvim.lua")
    vim.cmd("source ./.nvim.lua")
end
