local M = {}

---@class DoOptions
---@field message_timeout number how long a message (eg. for Done!) should be displayed in ms
---@field use_winbar boolean use winbar as display
---@field kaomoji_mode number 0: most kaomojis, 1: disable kaomiji in doing mode
---@field doing_prefix string Prefix for Doing-View, default: "Doing: "
---@field store TaskStoreOptions
M.default_opts = {
  message_timeout = 2000,
  kaomoji_mode = 0,
  doing_prefix = "Doing: ",
  use_winbar = false,

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
---@field auGroupId number | nil
M.state = {
  view_enabled = true,
  tasks = nil,
  message = nil,
  kaomoji = nil,
  options = M.default_opts,
  auGroupId = nil
}

return M
