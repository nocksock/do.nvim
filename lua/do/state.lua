local M = {}

---@class DoOptions
---@field message_timeout number how long a message (eg. for Done!) should be displayed in ms
---Right now there's only the option to enable the winbar, but in future
---versions there will be some more control over its behaviour regarding
---non-current windows.
---@field winbar WinbarOptions|boolean
---@field use_winbar boolean DEPRECATED: use winbar field instead.
---@field kaomoji_mode number 0: most kaomojis, 1: disable kaomiji in doing mode
---@field doing_prefix string Prefix for Doing-View, default: "Doing: "
---@field store TaskStoreOptions
M.default_opts = {
  message_timeout = 2000,
  kaomoji_mode = 0,
  doing_prefix = "Doing: ",
  use_winbar = false,

  ---@class WinbarOptions
  ---@field enabled boolean let do.nvim handle the winbar for you. 
  winbar = {
    enabled = false,
  },

  ---@class TaskStoreOptions
  store = {
    auto_create_file = false,
    file_name = ".do_tasks"
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
  kaomoji = nil,
  options = M.default_opts,
  auGroupID = nil
}

return M
