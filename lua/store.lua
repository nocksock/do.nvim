---@class TaskStore
---@field state TaskStoreState
---@field options TaskStoreOptions
local M = {}

---@class TaskStoreState
local default_state = {
  options = {},
  ---@type nil | string
  file = nil,
  ---@alias Tasks string[]
  tasks = {}
}

---@param options TaskStoreOptions
local function create_file(options)
  local f = io.open(options.file_name, "w")
  assert(f, "couldn't create " .. options.file_name)
  f:write("")
  f:close()
  return options.file_name
end

---comment
---@param options TaskStoreOptions
---@param force? boolean force creation of file
local function get_file(options, force)
  local file = vim.fn.findfile(options.file_name, ".;")

  if file == "" and force then
    file = create_file(options)
  end

  if file == "" then
    return nil
  end

  local is_readable = vim.fn.filereadable(file) == 1
  assert(is_readable, string.format("file not %s readable", file))

  return file
end

---@param options TaskStoreOptions
local function read_file(options)
  local file = get_file(options)

  if not file then
    return {}
  end

  return vim.fn.readfile(file)
end

function M:save(force)
  if not self.state.file and (force or self.state.options.auto_create_file) then
    self.state.file = get_file(self.state.options, true)
    assert(self.state.file, "file not set despite saving")
  end

  if not self.state.file then
    return
  end

  if vim.fn.filewritable(self.state.file) then
    vim.fn.writefile(self.state.tasks, self.state.file)
  else
    error(string.format("Cannot write file %s", self.state.file))
  end

  return self
end

function M:current()
  return self.state.tasks[1]
end

function M:get()
  return self.state.tasks
end

---@param tasks Tasks
function M:set(tasks)
  self.state.tasks = tasks
  self:save()
end

function M:count()
  return #self:get()
end

function M:add(str, to_front)
  if to_front then
    table.insert(self.state.tasks, 1, str)
  else
    table.insert(self.state.tasks, str)
  end
  self:save()
  return self
end

function M:shift()
  local head = table.remove(self.state.tasks, 1)
  self:save()
  return head
end

---initialize task store
---@return TaskStore
M.init = function(options)
  ---@type TaskStoreState
  local state = {
    options = options,
    tasks = read_file(options) or {}
  }

  local o = {
    state = vim.tbl_deep_extend("keep", state, default_state),
  }

  return setmetatable(o, { __index = M })
end

return M
