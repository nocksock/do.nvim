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

function M:create_file()
  local name = self.options.file_name
  local cwd = vim.loop.cwd()
  local file = io.open(cwd .. "/" .. name, "w")
  assert(file, "couldn't create " .. name .. " in current cwd: " ..cwd)
  file:write("")
  file:close()
  return name
end

---@param force? boolean force creation of file
function M:find_file(force)
  local options = self.options
  local file = vim.fn.findfile(vim.loop.cwd() .. "/" .. options.file_name, ".;")

  if file == "" and force then
    file = self:create_file()
  end

  if file == "" then
    return nil
  end

  local is_readable = vim.fn.filereadable(file) == 1
  assert(is_readable, string.format("file not %s readable", file))

  return file
end

function M:import_file()
  self.file = self:find_file()
  return self.file and vim.fn.readfile(self.file) or nil
end

function M:sync(force)
  if not self.file and (self.options.auto_create_file or force) then
    self.file = self:create_file()
    assert(self.file, "file not set despite saving")
  elseif not self.file then
    return self
  end

  if vim.fn.filewritable(self.file) then
    vim.fn.writefile(self.tasks, self.file)
  else
    error(string.format("Cannot write file %s", self.file))
  end

  return self
end

function M:current()
  return self.tasks[1]
end

function M:get()
  return self.tasks
end

---@param tasks Tasks
function M:set(tasks)
  self.tasks = tasks
  return self:sync()
end

function M:count()
  return #self:get()
end

---@param str string 
---@param to_front boolean
---@return TaskStore
function M:add(str, to_front)
  if to_front then
    table.insert(self.tasks, 1, str)
  else
    table.insert(self.tasks, str)
  end

  return self:sync()
end

function M:shift()
  return table.remove(self.tasks, 1), self:sync()
end

---initialize task store
M.init = function(options)
  ---@type TaskStoreState
  local tmp_state = {
    options = options,
    tasks = {}
  }

  local o = vim.tbl_deep_extend("keep", tmp_state, default_state)
  local instance = setmetatable(o, { __index = M })

  local state = require("doing.state").state
  vim.api.nvim_create_autocmd("DirChanged", {
    group = state.auGroupID,
    callback = function()
      local store = require("doing.store")
      state.tasks = store.init(state.options.store)
    end,
  })

  return instance:set(instance:import_file() or {})
end

function M:has_items()
  return self:count() > 0
end

return M
