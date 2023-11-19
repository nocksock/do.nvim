---@type DoAction
return function (item)
  return function(prev_state)
    table.insert(prev_state.todos, item)
    return prev_state
  end
end
