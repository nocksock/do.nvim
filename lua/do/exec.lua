--- @param event DoEvent
return function(event)
  local state = require'do.state'
  require'do.update'(
    require'do.dispatch'(event.action(event.args), state.get())
  )
end
