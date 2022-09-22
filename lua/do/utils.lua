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

-- local memo_store = {}
-- setmetatable(memo_store, {__mode = "v"})  -- make values weak
-- function M.memo_random(table, seed)
-- local key = seed or math.random(#table)

-- if memo_store[key] then
-- return memo_store[key]
-- else
-- local newcolor = table[math.random(#table)]
-- memo_store[key] = newcolor
-- return newcolor
-- end
-- end

--- Render winbar depending on if there are tasks. Return true if winbar was rendered. False if winbar was disabled
---@return boolean
function M.render_winbar()
   if vim.fn.win_gettype() == "" and vim.bo.buftype ~= "prompt" then
      if state.tasks:count() > 0 then
         vim.wo.winbar = view.render(state)
      else
         vim.wo.winbar = ""
      end
   end
   return false
end
return M
