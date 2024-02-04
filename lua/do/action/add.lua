---@type DoAction<string>
return function(item)
  return function(state)
    if item == "" then
      vim.ui.input({ prompt = 'Todo: ' }, function(input)
        item = input
      end)
    end

    if type(item) == "string" then
      item = { task = item, done = false }
    end

    table.insert(state.todos, item)

    if not state.current_todo then
      state.current_todo = 1
    end

    return state
  end
end
