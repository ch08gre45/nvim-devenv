local dap = require('dap')
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require "telescope.config".values

dap.adapters.coreclr = {
    type = 'executable',
    command = 'netcoredbg',
    args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        env = function ()
            local current_path = vim.fn.expand('%:p:h')
            local launchSettingsFiles = vim.fs.find(
                {'launchSettings.json'},
                {limit=math.huge, type='file', path=current_path})

            local co = coroutine.running()
            local opts = opts or {}
            opts.cwd = opts.cwd or vim.uv.cwd()

            local launchSettings
            if #launchSettingsFiles > 1 then
                pickers.new(opts, {
                    debounce = 100,
                    prompt_title = "Pick launchSettings.json",
                    finder = finders.new_table(launchSettingsFiles),
                    previewer = conf.grep_previewer(opts),
                    sorter = require("telescope.sorters").empty(),
                    attach_mappings = function(prompt_bufnr, map)
                        actions.select_default:replace(function()
                          local selection = action_state.get_selected_entry()
                          actions.close(prompt_bufnr)
                          launchSettings = selection[1]
                          if co then coroutine.resume(co) end
                        end)
                        return true
                    end,
                }):find()
                coroutine:yield()
            else
                launchSettings = launchSettingsFiles[1]
            end
            local stat = vim.uv.fs_stat(launchSettings)
            if stat == nil then return nil end

            local success, result = pcall(vim.fn.json_decode, vim.fn.readfile(launchSettings, ""))
            if not success then return nil, "Error parsing JSON: " .. result end

            local launchSettingsKeys = {}
            for key, _ in pairs(result.profiles) do
                table.insert(launchSettingsKeys, key)
            end

            local profileName
            pickers.new(opts, {
                debounce = 100,
                prompt_title = "Pick a profile",
                finder = finders.new_table({
                    results = launchSettingsKeys,
                    entry_maker = function (entry)
                        return {
                            value = entry,
                            display = entry,
                            ordinal = entry,
                        }
                    end
                }),
                previewer = previewers.new_termopen_previewer({
                    get_command = function(entry)
                        local json_string = vim.fn.json_encode(result.profiles[entry.value]) or "{}"
                        return { "bash", "-c", "cat <<EOF | jq --color-output '.'\n" .. json_string .. "\nEOF"}
                    end
                }),
                sorter = conf.generic_sorter({}),
                attach_mappings = function(prompt_bufnr, map)
                    actions.select_default:replace(function()
                      local selection = action_state.get_selected_entry()
                      print(vim.inspect(selection))
                      actions.close(prompt_bufnr)
                      profileName = selection.value
                      if co then coroutine.resume(co) end
                    end)
                    return true
                end,
            }):find()
            coroutine:yield()

            local profile = result.profiles[profileName]
            print(vim.inspect(profileName))
            print(vim.inspect(profile))
            return profile.environmentVariables
        end,
        program = function()
            local current_path = vim.fn.expand('%:p:h')
            local csproj_file = vim.fn.glob(current_path .. '/*.csproj')

            if csproj_file == "" then
                return ""
            end
            local csproj_name = vim.fn.fnamemodify(csproj_file, ":t:r")
            local matching_dll = csproj_name .. '.dll'
            print(vim.fs.joinpath(current_path, '/bin/Debug/net8.0/', matching_dll))
            return vim.fs.joinpath(current_path, '/bin/Debug/net8.0/', matching_dll)
        end,
    },
}
