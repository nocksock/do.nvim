local kaomoji = require("do.kaomojis")
local view = require('do.view')
local edit = require('do.edit')
local store = require('do.store')
local C = {}

---@class DoOptions
---@field message_timeout number how long a message (eg. for Done!) should be displayed in ms
---@field kaomoji_mode number 0: most kaomojis, 1: disable kaomiji in doing mode 
---@field doing_prefix string Prefix for Doing-View, default: "Doing: "
---@field store TaskStoreOptions
local default_opts = {
  message_timeout = 2000,
  kaomoji_mode = 1,
  doing_prefix = "Doing: ",

  ---@class TaskStoreOptions
  store = {
    auto_create_file = false,
    file_name = ".do_tasks",
  }
}

---@class DoState
---@field message? string
---@field tasks nil | TaskStore
---@field options DoOptions
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

C.view_inactive = function()
  return view.render_inactive(state)
end

return C
