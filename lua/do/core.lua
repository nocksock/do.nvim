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
  kaomoji_mode = 0,
  doing_prefix = "Doing: ",

  ---@class TaskStoreOptions
  store = {
    auto_create_file = false,
    file_name = ".do_tasks"
  }
}

---@class DoState
---@field message? string
---@field tasks nil | TaskStore
---@field options DoOptions
C.state = {
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
  C.state.message = "%#" .. (hl or "TablineSel") .. "#" .. str

  vim.defer_fn(function()
    C.state.message = nil
  end, default_opts.message_timeout)
end

---@param str string
---@param to_front boolean
function C.add(str, to_front)
  C.state.tasks:add(str, to_front)
end

function C.done()
  if C.state.tasks:count() == 0 then
    C.show_message(kaomoji.confused() .. " There was nothing left to do…", "InfoMsg")
    return
  end

  C.state.tasks:shift()

  if C.state.tasks:count() == 0 then
    C.show_message(kaomoji.joy() .. " ALL DONE! " .. kaomoji.joy(), "TablineSel")
  else
    C.show_message(kaomoji.joy() .. " Great! Only " .. C.state.tasks:count() .. " to go.", "MoreMsg")
  end
end

function C.edit()
  edit.toggle_edit(C.state.tasks:get(), function(new_todos)
    C.state.tasks:set(new_todos)
  end)
end

function C.save()
  C.state.tasks:sync(true)
end

---@param opts DoOptions
function C.setup(opts)
  C.state.options = vim.tbl_deep_extend("force", default_opts, opts or {})
  C.state.tasks = store.init(C.state.options.store)

  return C
end

function C.toggle()
  C.state.view_enabled = not C.state.view_enabled
end

C.statusline = "%!v:lua.DoStatusline()"

function C.view()
  return view.render(C.state)
end

function C.view_inactive()
  return view.render_inactive(C.state)
end

function C.has_items()
  return C.state.tasks:count() > 0
end

function C.is_visible()
  return C.state.view_enabled and C.has_items()
end

return C
