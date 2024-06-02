---@return DoState
return function(file_contents)
  ---@type DoTodo[]
  local todos = {}

  ---@param line string
  for _, line in ipairs(file_contents) do
    ---@type DoTodo
    local todo = {
      task = line,
      source = "do.sources.file",
      done = false
    }
    table.insert(todos, todo)
  end

  return todos
end
