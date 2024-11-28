local M = {}

---@class DoOptions
---@field message_timeout number how long a message (eg. for Done) should be displayed in ms
---Right now there's only the option to enable the winbar, but in future
---versions there will be some more control over its behaviour regarding
---non-current windows.
---@field winbar WinbarOptions Currenty only has the enabled option: winbar = { enabled = true }
---@field doing_prefix string Prefix for Doing-View, default: "Doing: "
---@field store TaskStoreOptions
M.default_opts = {
  message_timeout = 2000,
  doing_prefix = "Doing: ",


  ---@class WinbarOptions
  ---@field enabled boolean let doing.nvim handle the winbar for you.
  ---@field ignored_buffers table filetypes to ignore
  winbar = {
    enabled = true,
    ignored_buffers = { "NvimTree" },
  },

  ---@class TaskStoreOptions
  store = {
    auto_create_file = true,
    file_name = ".tasks"
  }
}

---@class DoState
---@field message? string
---@field tasks nil | TaskStore
---@field options DoOptions
---@field auGroupID number | nil
M.state = {
  view_enabled = true,
  tasks = nil,
  message = nil,
  options = M.default_opts,
  auGroupID = nil
}

return M
