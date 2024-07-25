local M = {}

M.search_buf_no = 0
M.term_channel = 0
M.query = "-e='__query__' ./"
M.sep = "---------------------"

local open_rg_buffer = function(query_external)
    M.search_buf_no = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(M.search_buf_no, "filetype", "terminal")
    local window_handle = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(window_handle, M.search_buf_no)

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
        print("not in a ripgrep search buffer")
        return
    end
    local query = vim.api.nvim_buf_get_lines(M.search_buf_no, 0, 1, true)
    if #query < 1 or #query > 1 then
        print("something is wrong with the query")
        return
    end

    local command = {"rg", "--line-number", "--no-heading", "--field-match-separator=__field__"}
    local temp = {}
    for token in query[1]:gmatch("%S+") do
        if token:find("'") then
            if #temp > 0 then
                -- dump temp table parts to command and reset it
                local concatenated_value = ""
                for k, v in pairs(temp) do
                    if k == 1 then
                        concatenated_value = v
                    else
                        concatenated_value = concatenated_value .. " " .. v
                    end
                end
                concatenated_value = concatenated_value .. " " .. token
                table.insert(command, concatenated_value)
                temp = {}
            else
                -- nothing currently in temp and found quote, start stacking until next quote found
                table.insert(temp, token)
            end
        else
            if #temp > 0 then
                -- no quote, but temp table not empty, probably in the middle of a quoted part, so stack
                table.insert(temp, token)
            else
                -- no quote, no temp table, just append to cmd
                table.insert(command, token)
            end
        end
    end

    print(vim.inspect(command))

    vim.fn.jobstart(command, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            local processed_data = {}
            for k, line in pairs(data) do
                if string.len(line) > 0 then
                    local s1,e1 = string.find(line, "__field__")
                    local s2,e2 = string.find(line, "__field__", e1)
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

function get_visual_selection()
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
    --rg_search()
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
    vim.keymap.set("n", "<leader>f", "<Cmd>RipgrepSearch<CR>", { silent = true })
end

function M.setup(opts)
    setup_commands()
end

M.setup()
