-- Attempts to align rows based on an anchor
-- ex: turns
-- const ONE = 1
-- const THREE = 3
-- into
-- const ONE   = 1 
-- const THREE = 3

-- Look for the following anchors
-- Use longer ones (i.e. more specific) first
local anchors = {"=>","=",":"}

local execute = function()
    bufnr = vim.api.nvim_get_current_buf()

    local cursor_position = vim.api.nvim_win_get_cursor(0) 
    local line = cursor_position[1]

    local current_line_text = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]

    local padding_current_line = 0
    local anchor
    for index, potential_anchor in ipairs(anchors) do
        local anchor_start, anchor_end = string.find(current_line_text, potential_anchor)
        if anchor_start then
            anchor = potential_anchor
            padding_current_line = anchor_start
            break
        end
    end

    if anchor == nil then
        vim.notify "No anchor was given or could be inferred from selection"
        return
    end

    local padding_indexes_upper = {}
    local padding_max = 0

    -- find upper bound
    local line_bound_upper = line
    local found_upper = false
    while not found_upper do
        local next_line_text = vim.api.nvim_buf_get_lines(bufnr, line_bound_upper - 2, line_bound_upper - 1, false)
        if #next_line_text == 0 then
            found_upper = true
        end
        local anchor_start, anchor_end = string.find(next_line_text[1], anchor)
        if anchor_start then
            if anchor_start > padding_max then
                padding_max = anchor_start
            end
            line_bound_upper = line_bound_upper - 1
            padding_indexes_upper[#padding_indexes_upper + 1] = anchor_start
        else
            found_upper = true
        end
    end

    -- find lower bound
    local padding_indexes_lower = {}
    local line_bound_lower = line
    local found_lower = false
    while not found_lower do
        local next_line_text = vim.api.nvim_buf_get_lines(bufnr, line_bound_lower, line_bound_lower + 1, false)
        if #next_line_text == 0 then
            found_lower = true
        end
        local anchor_start, anchor_end = string.find(next_line_text[1], anchor)
        if anchor_start then
            if anchor_start > padding_max then
                padding_max = anchor_start
            end
            line_bound_lower = line_bound_lower + 1
            padding_indexes_lower[#padding_indexes_lower + 1] = anchor_start
        else
            found_lower = true
        end
    end

    local lines_to_replace = vim.api.nvim_buf_get_lines(bufnr, line_bound_upper - 1, line_bound_lower, false)

    aligned_lines = {}
    for i, line in pairs(lines_to_replace) do
        local pos = 0
        local pad = 0
        local new = ""
        if i <= #padding_indexes_upper then
            -- upper
            pos = padding_indexes_upper[#padding_indexes_upper + 1 - i]
            pad = padding_max - pos
        elseif i == #padding_indexes_upper + 1 then
            -- current
            pos = padding_current_line
            pad = padding_max - pos
        else
            -- lower
            pos = padding_indexes_lower[i - #padding_indexes_upper - 1]
            pad = padding_max - pos
        end
        new = line:sub(1, pos - 1)..string.rep(" ", pad)..line:sub(pos)
        aligned_lines[i] = new
    end

    vim.api.nvim_buf_set_lines(bufnr, line_bound_upper - 1, line_bound_lower, true, aligned_lines)
end

vim.api.nvim_create_user_command(
    "Valign",
    function ()
        execute()
    end, 
    {}
)

vim.api.nvim_set_keymap('n', '<space>tt', '<cmd>Valign<CR>', { noremap=true })
