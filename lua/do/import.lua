---@param tasks DoTodo
return function(tasks)
  for _, value in ipairs(tasks) do
    require 'do'.dispatch("add", value)
  end
end
