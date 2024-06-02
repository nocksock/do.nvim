return function(file)
  local file_contents = vim.fn.readfile(file)
  ---@type DoTodo[]
  local todos = {}

  ---@param line string
  for _, line in ipairs(file_contents) do
    ---@type DoTodo
    local todo = {
      task = line,
      source = "do.sources.file",
    }
    table.insert(todos, todo)
  end

  return todos
end
