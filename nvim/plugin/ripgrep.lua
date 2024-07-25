local M = {}

M.search_buf_no = 0
M.query = "rg -e='__query__' ./"
M.sep = "---------------------"
M.filetype = "ripgrep"

local open_rg_buffer = function(query_external)
    M.search_buf_no = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(M.search_buf_no, "filetype", M.filetype)
    local window_handle = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(window_handle, M.search_buf_no)

    -- Replace ripgrep keybinds when in this buffer
    vim.keymap.set("n", "<C-f>", "<Cmd>RipgrepSearch<CR>", { silent = true, buffer = M.search_buf_no })
    vim.keymap.set("n", "<C-g>", "3GdGgg^", { silent = true, buffer = M.search_buf_no })

    local query = M.query
    if query_external ~= nil and query_external ~= "" then
        query = M.query:gsub("__query__", query_external)
    end
    vim.api.nvim_buf_set_lines(M.search_buf_no, 0, 0, false, {query, M.sep})
    vim.api.nvim_win_set_cursor(window_handle, {1, 0})
end

local rg_search = function()
    local current_buf = vim.api.nvim_get_current_buf()
    if current_buf ~= M.search_buf_no then
        if vim.bo.filetype == M.filetype then
            M.search_buf_no = current_buf
        else
            print("not in a ripgrep search buffer")
            return
        end
    end
    local query = vim.api.nvim_buf_get_lines(M.search_buf_no, 0, 1, true)
    if #query < 1 or #query > 1 then
        print("something is wrong with the query")
        return
    end

    vim.fn.jobstart(query[1]:gsub("^rg", "rg --line-number --no-heading --field-match-separator=__f__"), {
        stdout_buffered = true,
        on_stdout = function(_, data)
            local processed_data = {}
            for k, line in pairs(data) do
                if string.len(line) > 0 then
                    local s1,e1 = string.find(line, "__f__")
                    local s2,e2 = string.find(line, "__f__", e1)
                    if s1 ~= nil and s2 ~= nil and e1 ~= nil and e2 ~= nil then
                        local name = string.sub(line, 0, s1-1)
                        local line_no = string.sub(line, e1+1, s2-1)
                        local rest = string.sub(line, e2+1, string.len(line))
                        table.insert(processed_data, name..":"..line_no)
                        table.insert(processed_data, rest)
                        table.insert(processed_data, "")
                    end
                end
            end
            vim.api.nvim_buf_set_lines(M.search_buf_no, -1, -1, false, processed_data)
        end,
        on_stderr = function(_, data)
            vim.api.nvim_buf_set_lines(M.search_buf_no, -1, -1, false, data)
        end,
    })
end

local get_visual_selection = function ()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg('v')
	vim.fn.setreg('v', {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ''
	end
end

local rg_with_query = function()
    local query = get_visual_selection()
    if query == "" or query == nil then
        print("No text highlighted")
        return
    end
    open_rg_buffer(query)
    rg_search()
end

local escape = function(text)
    local escaped_text = text
    escaped = escaped:gsub("(", "\\(")
    escaped = escaped:gsub(")", "\\)")
end

local setup_commands = function()
    vim.api.nvim_create_user_command(
        "Ripgrep",
        function (opts)
            open_rg_buffer()
        end, 
        { nargs = 0 }
    )
    vim.api.nvim_create_user_command(
        "RipgrepWithQuery",
        function (opts)
            rg_with_query()
        end, 
        { nargs = 0 }
    )
    vim.api.nvim_create_user_command(
        "RipgrepSearch",
        function()
            rg_search()
        end,
        { nargs = 0 }
    )

    vim.keymap.set("n", "<C-g>", "<Cmd>Ripgrep<CR>", { silent = true })
    vim.keymap.set("v", "<C-f>", "<Cmd>RipgrepWithQuery<CR>", { silent = true })
end

function M.setup(opts)
    setup_commands()
end

M.setup()
