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

--- Redraw winbar depending on if there are tasks. Redraw if there are pending tasks, other wise set to ""
function M.redraw_winbar()
   if vim.fn.win_gettype() == "" and vim.bo.buftype ~= "prompt" then
      -- if there are tasks, make winbar visible
      if state.tasks:count() > 0 then
         vim.wo.winbar = view.stl
      else
         -- other wise hide it
         vim.wo.winbar = ""
      end
   end
end

--- execute the auto command when a task is modified
function M.exec_task_modified_autocmd()
   vim.api.nvim_exec_autocmds("User", {
      pattern = "TaskModified",
      group = state.auGroupId,
   })
end


return M
