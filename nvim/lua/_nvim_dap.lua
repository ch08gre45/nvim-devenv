local dap = require('dap')

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
        local launchSettings = vim.fs.joinpath(current_path, "Properties", "launchSettings.json")

        local stat = vim.uv.fs_stat(launchSettings)
        if stat == nil then return nil end

        local success, result = pcall(vim.fn.json_decode, vim.fn.readfile(launchSettings, ""))
        if not success then return nil, "Error parsing JSON: " .. result end

        local profiles = vim.tbl_keys(result.profiles)
        local profileName = vim.fn.input('Profile name:', profiles[1])
        local profile = result.profiles[profileName]
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
