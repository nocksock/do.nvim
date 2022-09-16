local ui = require('ui')
local kaomoji = require("kaomojis")

local M = {}

---@class DoOptions
local default_opts = {
  use_winbar = false,
  message_timeout = 2000,

  ---@class TaskStoreOptions
  store = {
    auto_create_file = false,
    file_name = ".do_tasks",
  }
}

---@class DoState
---@field message? string
local state = {
  tasks = require('store'),
  view_enabled = true,
  message = nil,
  options = default_opts
}

function M.view()
  if not state.view_enabled then
    return ""
  end

  -- using pcall so that it won't spam error messages
  local ok, display = pcall(function()
    local count = state.tasks:count()
    local display = ""
    local aligned = false

    if state.message then
      return state.message
    end

    if count == 0 then
      return ""
    end

    display = "%#TablineSel# Doing: " .. state.tasks:current()

    if count > 1 then
      display = display .. "%=+" .. (count - 1 ) .. " more "
      aligned = true
    end

    if not state.tasks.state.file then
      display = display .. (aligned and "" or "%=") .."(:DoSave)"
    end

    return display
  end)

  if not ok then
    return "ERR: " .. display
  end

  return display
end

---Show a message for the duration of `options.message_timeout`
---@param str string Text to display
---@param hl? string Highlight group
function M.show_message(str, hl)
  state.message = "%#" .. (hl or "TablineSel") .. "#" .. str

  vim.defer_fn(function ()
    state.message = nil
  end, default_opts.message_timeout)
end

---@param str string
---@param to_front boolean
function M.add(str, to_front)
  state.tasks:add(str, to_front)
end

function M.done()
  if state.tasks:count() == 0 then
    M.show_message(kaomoji.confused() .. " There was nothing left to do…", "InfoMsg")
    return
  end

  local did = state.tasks:shift()

  if state.tasks:count() == 0 then
    M.show_message(kaomoji.joy() .. " did: " .. did .. ". ALL DONE! " .. kaomoji.joy(), "TablineSel")
  else
    M.show_message(kaomoji.joy() .. " did: " .. did .. ". Only " .. state.tasks:count() .. " to go.", "MoreMsg")
  end
end

function M.clear()
  state.tasks:clear()
  M.show_message(kaomoji.doubt() .. " Cleared all todos.", "WarningMsg")
end

M.edit = function()
  ui.toggle_edit(state.tasks:get(), function(new_todos)
    state.tasks:set(new_todos)
  end)
end

M.save = function()
  state.tasks:save(true)
end

---@param opts DoOptions
M.setup = function(opts)
  state.options = vim.tbl_deep_extend("force", default_opts, opts or {})
  state.tasks = R("store").init(state.options.store)

  if state.options.use_winbar then
    vim.o.winbar = M.statusline
  end

  return M
end

M.toggle = function()
  state.view_enabled = not state.view_enabled
end

M.statusline = "%!v:lua.DoStatusline()"

return M
