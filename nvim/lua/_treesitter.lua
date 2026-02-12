require'nvim-treesitter'.setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}
require'nvim-treesitter'.install {
      "go",
      "php",
      "python",
      "javascript",
      "typescript",
      "tsx",
      "lua",
      "bash",
      "c_sharp",
      "html",
      "css",
      "yaml",
      "query",
      "rust",
      "ocaml",
      "glsl"
  }
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go' },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'php' },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'py' },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'js' },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'ts' },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua' },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh' },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'cs' },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'html' },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'css' },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'yml' },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rs' },
  callback = function() vim.treesitter.start() end,
})
