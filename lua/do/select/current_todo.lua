---@param state DoState
return function(state)
  local current_todo_index = state.current_todo or 1
  if current_todo_index > #state.todos then
    current_todo_index = 1
  end

  if #state.todos == 0 then
    return {}
  end

  return state.todos[current_todo_index]
end
