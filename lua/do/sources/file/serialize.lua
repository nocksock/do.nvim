---@param state DoState
---@param opts DoSourceFileOptions
---@return string[]
return function(state, opts)
  local tasks = {}

  for k, todo in ipairs(state.todos) do
    local prefix = todo.done and opts.task_prefix.done or opts.task_prefix.todo
    table.insert(tasks, string.format("%s %s", prefix, todo.task))
  end

  return tasks
end
