require'nvim-treesitter.configs'.setup {
  ensure_installed = {
      "go",
      "php",
      "javascript",
      "lua",
      "bash",
      "c_sharp",
      "html",
      "css",
      "yaml",
  },
  sync_install = false,
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = true,
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            "function",
            "method",
            "for",
            "while",
            "if",
            "switch",
            "case",
        },

        rust = {
            "loop_expression",
            "impl_item",
        },

        typescript = {
            "class_declaration",
            "abstract_class_declaration",
            "else_clause",
        },
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
-- Inject proper languages in html file
require("vim.treesitter.query").set_query("php", "injections", [[
; inherits: html

(text) @html

(comment) @phpdoc
]])
