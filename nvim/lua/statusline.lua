local modes = {
    ["n"] = "NORMAL",
    ["no"] = "NORMAL",
    ["v"] = "VISUAL",
    ["V"] = "VISUAL LINE",
    [""] = "VISUAL BLOCK",
    ["s"] = "SELECT",
    ["S"] = "SELECT LINE",
    [""] = "SELECT BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rv"] = "VISUAL REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "VIM EX",
    ["ce"] = "EX",
    ["r"] = "PROMPT",
    ["rm"] = "MOAR",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
}

local color = {
    ["black"] = "#393b44",
    ["red"] = "#c94f6d",
    ["green"] = "#81b29a",
    ["yellow"] ="#dbc074",
    ["blue"] =  "#719cd6",
    ["magenta"] = "#9d79d6",
    ["cyan"] =  "#63cdcf",
    ["white"] = "#dfdfe0",
    ["orange"] ="#f4a261",
    ["pink"] =  "#d67ad2",
    ["white_fg"] = "#b8b894",
    ["black_fg"] = "#282c34",
    ["none"] = "None",
}

local function mode()
    local current_mode = vim.api.nvim_get_mode().mode
    return string.format(" %s ", modes[current_mode]):upper()
end

local function filepath()
    local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
    if fpath == "" or fpath == "." then
        return " "
    end

    return string.format(" %%<%s/", fpath)
end

local function filename()
    local fname = vim.fn.expand "%:t"
    if fname == "" then
        return "[no name]"
    end
    return fname .. " "
end

local function lsp()
    local count = {}
    local levels = {
        errors = "Error",
        warnings = "Warn",
        info = "Info",
        hints = "Hint",
    }

    for k, level in pairs(levels) do
        count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    end

    local errors = ""
    local warnings = ""
    local hints = ""
    local info = ""

    if count["errors"] ~= 0 then
        errors = string.format("%%#Error# e %s ", count["errors"])
    end
    if count["warnings"] ~= 0 then
        warnings = string.format("%%#Warning# w %s ",  count["warnings"])
    end
    if count["hints"] ~= 0 then
        hints = string,format("%%#Hint# h %s ", count["hints"])
    end
    if count["info"] ~= 0 then
        info = string.format("%%#Info# i %s ", count["info"])
    end

    return string.format("%s%s%s%s", errors, warnings, hints, info)
end

local function filetype()
    return string.format(" %s ", vim.bo.filetype):upper()
end

local function lineinfo()
    if vim.bo.filetype == "alpha" then
        return ""
    end
    return " l %-3.l c %-3.c %-3.P"
end

local function git_branch()
    local fugitive = vim.fn.FugitiveStatusline()
    local _, _, branch = string.find(fugitive, "%((%a+)%)")
    if branch == nil then
        return "|no scm|"
    end
    return string.format("|%s|", branch )
end

local function fileencoding()
    return vim.bo.fileencoding
end

local function set_colors()
    vim.api.nvim_command('hi Error guibg=' .. color["red"] .. ' guifg=' .. color["black_fg"])
    vim.api.nvim_command('hi Warning guibg=' .. color["yellow"] .. ' guifg=' .. color["black_fg"])
    vim.api.nvim_command('hi Hint guibg=' .. color["cyan"] .. ' guifg=' .. color["black_fg"])
    vim.api.nvim_command('hi Info guibg=' .. color["black_fg"] .. ' guifg=' .. color["white_fg"])
end

Statusline = {}

Statusline.active = function()
    set_colors()
    return table.concat {
        "%#Statusline#",
        git_branch(),
        filetype(),
        fileencoding(),
        "%#Statusline#",
        "%=%",
        filepath(),
        filename(),
        "%=%#StatusLineExtra#",
        lsp(),
        "%#Statusline#",
        lineinfo(),
    }
end

function Statusline.inactive()
    return " %F"
end

function Statusline.short()
    return "%#StatusLineNC#  NvimTree"
end

vim.api.nvim_exec([[
    augroup Statusline
    au!
    au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
    au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
    au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.short()
    augroup END
]], false)
