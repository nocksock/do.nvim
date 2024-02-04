---@type DoAction
return function ()
  ---@param state DoState
  return function(state)
    table.remove(state.todos, state.current_todo)

    if state.current_todo > #state.todos then
      state.current_todo = #state.todos
    end

    vim.notify(require'do.text'.message_done())
  end
end
