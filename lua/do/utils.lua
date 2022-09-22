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

--- Render winbar depending on if there are tasks. Return true if winbar was rendered. False if winbar was disabled
---@return boolean
function M.redraw_winbar()
   if vim.fn.win_gettype() == "" and vim.bo.buftype ~= "prompt" then
      if state.tasks:count() > 0 then
         vim.wo.winbar = view.stl
      else
         vim.wo.winbar = ""
      end
   end
   return false
end
return M
