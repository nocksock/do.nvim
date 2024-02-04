local M = {}

---@alias DoSourceLoad fun(DoSourceOptions): DoTodo[]
---@alias DoSourceSave fun(DoState): nil
---@alias DoSource { load: DoSourceLoad, save: DoSourceSave }

---@class DoState : table
---@field current_todo number | nil
---@field options DoOptions
---@field todos DoTodo[]

--- @class DoOptions
--- @field register_command boolean
local default_options = {
  register_command = true,
  ---@type string[]
  views = {
    'do.views.winbar',
  },
  ---@type string[]
  sources = {
    'do.sources.file'
  },
  ['do.sources.file'] = {
    file = '.todos.do',
  },
  show_winbar = true,
  show_notifications = true,
}

local initialState = {
  current_todo = nil,
  todos = {},
  options = default_options,
}

local state

---@param new_state DoState
function M.set(new_state)
  state = new_state
  return new_state
end

function M.get()
  if not state then
    error("State not initialized. Call require'do'.setup {} first.")
  end

  return state
end

---@param opts DoOptions
---@return DoState
function M.init(opts)
  state = vim.deepcopy(initialState)
  state.options = vim.tbl_extend("force", default_options, opts or {})
  return state
end

return M
