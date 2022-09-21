local kaomojis = require("do.kaomojis")
local View = {}

function View.is_visible(state)
  return state.view_enabled and state.tasks:has_items()
end

---Create a winbar string for the current task
---@param state DoState
---@return string
function View.render(state)
  if not View.is_visible(state) then
    return ""
  end

  -- using pcall so that it won't spam error messages
  local ok, display = pcall(function()
    local count = state.tasks:count()
    local display = ""
    local aligned = false
    local current = state.tasks:current()
    local kaomoji = state.options.kaomoji_mode == 0 and kaomojis.doing(current) or ""

    if state.message then
      return state.message
    end

    if count == 0 then
      return ""
    end

    display = [[ %#TablineSel# ]] .. kaomoji .. " " .. state.options.doing_prefix .. current

    -- append task count number if there are more than 1 tasks
    if count > 1 then
      display = display .. "%=+" .. (count - 1 ) .. " more "
      aligned = true
    end

    if not state.tasks.file then
      display = display .. (aligned and "" or "%=") .."(:DoSave)"
    end

    return display
  end)

  if not ok then
    return "ERR: " .. display
  end

  return display
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
