--- @type DoAction
return function ()
  return function(state, resolve)
    vim.ui.select(state.todos, {
      prompt = "Select a todo",
    }, function(_, index)
      state.current_todo = index
    end)
  end
end
