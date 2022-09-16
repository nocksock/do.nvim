local kaomojis = require("do.kaomojis")
local View = {}

function View.render(state)
  if not state.view_enabled then
    return ""
  end

  -- using pcall so that it won't spam error messages
  local ok, display = pcall(function()
    local count = state.tasks:count()
    local display = ""
    local aligned = false
    local current = state.tasks:current()
    local kaomoji = kaomojis.doing(current)

    if state.message then
      return state.message
    end

    if count == 0 then
      return ""
    end

    display = "%#TablineSel# " .. kaomoji .. " Doing: " .. current

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

return View
