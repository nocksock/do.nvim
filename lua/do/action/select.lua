--- @type DoAction
return function()
  return function(state, resolve)
    local available_todos = {}
    for index, value in ipairs(state.todos) do
      table.insert(available_todos, value.task)
    end

    vim.ui.select(available_todos, {
      prompt = "Select a todo",
    }, function(_, index)
      state.current_todo = index
    end)
  end
end
