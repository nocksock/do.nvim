local state = require("doing.state").state
local store = require("doing.store")
local utils = require("doing.utils")

local View = {}

--- Weather the winbar should visible, when view_enabled is true, and there are items in the list
---@return boolean
function View.is_visible()
  return state.view_enabled and state.tasks:has_items() or not not state.message
end

---Create a winbar string for the current task
---@return string|table
function View.render()
  if (not state.view_enabled) or
      (not utils.should_display_task())
  then
    return ""
  end

  state.tasks = store.init(state.options.store)
  local right = ""

  -- using pcall so that it won't spam error messages
  local ok, left = pcall(function()
    local count = state.tasks:count()
    local res = ""
    local current = state.tasks:current()

    if state.message then
      return state.message
    end

    if count == 0 then
      return ""
    end

    res = state.options.doing_prefix .. current

    -- append task count number if there is more than 1 task
    if count > 1 then
      right = '+' .. (count - 1) .. " more"
    end

    return res
  end)

  if not ok then
    return "ERR: " .. left
  end

  if not right then
    return left
  end

  return left .. '  ' .. right
end

View.stl = "%!v:lua.DoStatusline('active')"
View.stl_nc = "%!v:lua.DoStatusline('inactive')"

return View
