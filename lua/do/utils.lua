local state = require("do.state").state
local M = {}

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

local memo_store = {}
setmetatable(memo_store, {__mode = "v"})  -- make values weak
function M.memo_random(table, seed)
  local key = seed or math.random(#table)

  if memo_store[key] then 
    return memo_store[key]
  else
    local newcolor = table[math.random(#table)]
    memo_store[key] = newcolor
    return newcolor
  end
end

--- execute the auto command when a task is modified
function M.exec_task_modified_autocmd()
   vim.notify("Running autocmd")
   vim.api.nvim_exec_autocmds("User", {
      pattern = "TaskModified",
      group = state.auGroupId,
   })
end


return M
