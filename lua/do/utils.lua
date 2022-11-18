local M = {}
local state = require('do.state').state
local view = require('do.view')

function M.is_white_space(str)
  return str:gsub("%s", "") == ""
end

function M.memoize(f)
  local meta = {}
  local table = setmetatable({}, meta)

  function meta:__index(key)
    local value = f(key)
    table[key] = value
    return value
  end

  return table
end

--- execute the auto command when a task is modified
function M.exec_task_modified_autocmd()
   vim.api.nvim_exec_autocmds("User", {
      pattern = "TaskModified",
      group = state.auGroupID,
   })
end

---Parse winbar options. Can also be used to determine whether winbar is managed
---by Do.nvim
---@param options WinbarOptions|boolean
---@return WinbarOptions|false
function M.parse_winbar_options(options)
  if type(options) == "boolean" then
    options = ({ enabled = options })
  end

  if options.enabled then
    return options
  end

  return false
end

---Check whether the current window/buffer can display a winbar
function M.can_have_winbar()
  return vim.fn.win_gettype() == "" and vim.bo.buftype ~= "prompt"
end

return M
