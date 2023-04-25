local ts_utils = require 'nvim-treesitter.ts_utils'
local make_prop_query = function(varname)
    local array_prop = vim.treesitter.query.parse(
        "php",
        "(subscript_expression\n" ..
        "    (variable_name\n" ..
        "      (name) @var (#eq? @var \"".. varname .. "\")\n" ..
        "    )\n" ..
        "    (encapsed_string\n" ..
        "      (string_value) @prop\n" ..
        "    )\n" ..
        ")"
        )
    return array_prop
end

local func_def_query = vim.treesitter.query.parse(
"php",
[[
(function_definition
) @func
]]
)


local get_root = function(bufnr)
    local parser = vim.treesitter.get_parser(bufnr, php, {})
    local tree = parser:parse()[1]
    return tree:root()
end

local execute = function(varname)
    bufnr = vim.api.nvim_get_current_buf()
    varname = varname or "p_obj"

    if vim.bo[bufnr].filetype ~= "php" then
        vim.notify "Only usable in PHP"
        return
    end

    local root = get_root(bufnr)
    local cursor_position = vim.api.nvim_win_get_cursor(0) 
    local r = cursor_position[1]
    print("Cursor @ l "..r)
    local r_s = -1
    local r_e = -1
    local func_node = nil

    for id, node, metadata in func_def_query:iter_captures(root, bufnr, 0, -1) do
        local name = func_def_query.captures[id]
        local range = { node:range() }
        print("func @ "..range[1].." - "..range[3])
        if (range[1] <= r and range[3] >= r) then
            print("match @ "..range[1].." - "..range[3])
            r_s = range[1]
            r_e = range[3]
            break
        end
    end
    print("search range ["..r_s.." - "..r_e.."]")

    local matched_props = {}
    if (r_s > 0 and r_e > 0) then
        local ap = make_prop_query(varname)
        for id, node, metadata in ap:iter_captures(root, bufnr, r_s, r_e) do
            local name = ap.captures[id]
            if (name == "prop") then
                local prop_name = vim.treesitter.query.get_node_text(node, bufnr)
                print(prop_name)
                if matched_props[prop_name] == nil then
                    matched_props[prop_name] = 1
                else
                    matched_props[prop_name] = matched_props[prop_name] + 1
                end
            end
        end
        print(matched_props)

        local prop_lines = {}
        local i = 1
        for prop, count in pairs(matched_props) do
            local prop_text = "* $"..varname.."["..prop.."] - insert_description"
            prop_lines[i] = prop_text
            i = i + 1
        end
        prop_lines[i] = ""
        vim.api.nvim_buf_set_text(bufnr, r_s - 2, 0, r_s - 2, 0, prop_lines)

    end

end

vim.api.nvim_create_user_command(
    "CHGetArrayProps",
    function (opts)
        local varname = opts.args
        execute(varname)
    end, 
    { nargs = 1 }
)
