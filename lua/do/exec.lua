local r = require
--- @param event DoEvent
return function(event)
  local state = r 'do.state'
  state.set(
    r 'do.dispatch' (event.action(event.args), state.get())
  )
end
