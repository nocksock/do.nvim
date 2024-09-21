local View = {}

--- Weather the winbar should visible, when view_enabled is true, and there are items in the list
---@param state DoState
---@return boolean
function View.is_visible(state)
  return state.view_enabled and state.tasks:has_items() or not not state.message
end

---Create a winbar string for the current task
---@param state DoState
---@return string|table
function View.render(state)
  if not View.is_visible(state) then
    return { left = '', middle = '', right = '' }
  end

  return require("doing.api").status()
end

function View.render_inactive(state)
  if not View.is_visible(state) then
    return ""
  end

  return "  "
end

View.stl = "%!v:lua.DoStatusline('active')"
View.stl_nc = "%!v:lua.DoStatusline('inactive')"

return View
