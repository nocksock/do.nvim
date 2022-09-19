local kaomoji = require("do.kaomojis")
local view = require('do.view')
local edit = require('do.edit')
local store = require('do.store')
local C = {}

---@class DoOptions
local default_opts = {
  message_timeout = 2000,

  ---@class TaskStoreOptions
  store = {
    auto_create_file = false,
    file_name = ".do_tasks",
  }
}

---@class DoState
---@field message? string
---@field tasks nil | TaskStore
local state = {
  view_enabled = true,
  tasks = nil,
  message = nil,
  kaomoji = nil,
  options = default_opts
}

---Show a message for the duration of `options.message_timeout`
---@param str string Text to display
---@param hl? string Highlight group
function C.show_message(str, hl)
  state.message = "%#" .. (hl or "TablineSel") .. "#" .. str

  vim.defer_fn(function ()
    state.message = nil
  end, default_opts.message_timeout)
end

---@param str string
---@param to_front boolean
function C.add(str, to_front)
  state.tasks:add(str, to_front)
end

function C.done()
  if state.tasks:count() == 0 then
    C.show_message(kaomoji.confused() .. " There was nothing left to do…", "InfoMsg")
    return
  end

  state.tasks:shift()

  if state.tasks:count() == 0 then
    C.show_message(kaomoji.joy() .. " ALL DONE! " .. kaomoji.joy(), "TablineSel")
  else
    C.show_message(kaomoji.joy() .. " Great! Only " .. state.tasks:count() .. " to go.", "MoreMsg")
  end
end

C.edit = function()
  edit.toggle_edit(state.tasks:get(), function(new_todos)
    state.tasks:set(new_todos)
  end)
end

C.save = function()
  state.tasks:sync(true)
end

---@param opts DoOptions
C.setup = function(opts)
  state.options = vim.tbl_deep_extend("force", default_opts, opts or {})
  state.tasks = store.init(state.options.store)

  return C
end

C.toggle = function()
  state.view_enabled = not state.view_enabled
end

C.statusline = "%!v:lua.DoStatusline()"

C.view = function()
  return view.render(state)
end

return C
