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
        local launchSettings = vim.fs.joinpath(vim.fn.getcwd(), "Properties", "launchSettings.json")

        local stat = vim.uv.fs_stat(launchSettings)
        if stat == nil then return nil end

        local success, result = pcall(vim.fn.json_decode, vim.fn.readfile(launchSettings, ""))
        if not success then return nil, "Error parsing JSON: " .. result end

        local profiles = vim.tbl_keys(result.profiles)
        local profileName = vim.fn.input('Profile name:', profiles[1])
        print("Chosen" .. profileName)
        local profile = result.profiles[profileName]
        print("exit " .. vim.inspect(profile))
        return profile.environmentVariables
    end,
    program = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}
