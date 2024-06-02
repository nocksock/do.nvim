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

    table.insert(state.todos, 1, item)
    state.current_todo = 1

    return state
  end
end
