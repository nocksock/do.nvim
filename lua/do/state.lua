local M = {}

---@alias DoSourceLoad fun(DoSourceOptions): DoTodo[]
---@alias DoSourceSave fun(DoState): nil
---@alias DoSource { load: DoSourceLoad, save: DoSourceSave }

---@class DoState : table
---@field current_todo number | nil
---@field options DoOptions
---@field todos DoTodo[]

--- @class DoOptions
M.default_options = {
  ---@type boolean
  register_command = true,
  ---@type string[]
  views = {
    'do.views.winbar',
  },
  ---@type string[]
  sources = {
    'do.sources.file'
  },
  show_winbar = true,
  show_notifications = true,
}

--- @class DoState
local initialState = {
  ---@type DoTodo
  current_todo = nil,
  ---@type DoTodo[]
  todos = {},
  ---@type DoOptions
  options = M.default_options,
}

local state
local listeners = {}

local is_callable = function(fn_or_table)
  if type(fn_or_table) == 'function' then
    return true
  end

  local mt = getmetatable(fn_or_table)
  if mt == nil then
    return false
  end

  if type(mt.__call) == 'function' then
    return true
  end
end

local get_listener_fn = function(view)
  if is_callable(view) then
    return view
  end

  if type(view) == 'table' and is_callable(view[1]) then
    return view[1]
  end
end

local get_clean_fn = function(view)
  if type(view) == 'table' and is_callable(view[2]) then
    return view[2]
  end
end

local remove = function(pred)
  for i, v in pairs(listeners) do
    if pred(v) then
      if type(v) == 'table' and type(v[2]) == 'function' then
        v[2]()
      end

      table.remove(listeners, i)
    end
  end
end

---@param new_state DoState
function M.set(new_state)
  state = vim.tbl_extend("force", state, new_state)
  for _, v in pairs(listeners) do
    get_listener_fn(v)(state)
  end
  return state
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
  state.options = vim.tbl_extend("force", M.default_options, opts or {})
  return state
end

function M.subscribe(callback, trigger)
  if not get_listener_fn(callback) then
    error("View is not callable. Needs to be a function or a table with a function as the first element.")
  end

  table.insert(listeners, callback)

  if trigger ~= false then
    get_listener_fn(callback)(M.get())
  end
end

function M.unsubscribe(callback)
  remove(function(sub) return callback == sub end)
end

function M.clear()
  remove(function()
    return true
  end)
end

return M
