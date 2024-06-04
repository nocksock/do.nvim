---@param line string
---@param opts DoSourceFileOptions
---@return DoTodo
local function parse_line(line, opts)
  local done_prefix = opts.task_prefix.done;
  local todo_prefix = opts.task_prefix.todo;

  if line:sub(1, #done_prefix) == done_prefix then
    return {
      task = line:sub(#done_prefix + 1),
      done = true,
      source = "do.sources.file"
    }
  end

  if line:sub(1, #todo_prefix) == todo_prefix then
    return {
      task = line:sub(#todo_prefix + 1),
      done = false,
      source = "do.sources.file"
    }
  end

  return {
    task = line,
    done = false,
    source = "do.sources.file"
  }
end

-- TODO: add type hint to this
local M = setmetatable({
  line = parse_line
}, {
  ---@param file_contents string[]
  ---@param opts DoSourceFileOptions
  ---@return DoState
  __call = function(file_contents, opts)
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
})

return M
