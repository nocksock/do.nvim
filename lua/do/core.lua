local kaomoji = require("do.kaomojis")
local view = require('do.view')
local edit = require('do.edit')
local store = require('do.store')
local state = require('do.state').state
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


---Show a message for the duration of `options.message_timeout`
---@param str string Text to display
---@param hl? string Highlight group
function C.show_message(str, hl)
  state.message = "%#" .. (hl or "TablineSel") .. "#" .. str

  vim.defer_fn(function()
    state.message = nil
  end, default_opts.message_timeout)
end

---add a task to the list
---@param str string task to add
---@param to_front boolean whether to add task to front of list
function C.add(str, to_front)
  state.tasks:add(str, to_front)
  vim.api.nvim_exec_autocmds("User", {
     pattern = "DoTaskAdd",
     group = state.auGroupId,
  })

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

function C.edit()
  edit.toggle_edit(state.tasks:get(), function(new_todos)
    state.tasks:set(new_todos)
  end)
end

function C.save()
  state.tasks:sync(true)
end

---@param opts DoOptions
function C.setup(opts)
  state.options = vim.tbl_deep_extend("force", default_opts, opts or {})
  state.tasks = store.init(state.options.store)

  state.auGroupId = vim.api.nvim_create_augroup("do_nvim", {
     clear = true,
  })

  -- vim.api.nvim_create_autocmd({ "User" }, {
     -- group = state.auGroupId,
     -- desc = "A task has been added",
     -- pattern = "DoTaskAdd",
     -- callback = function()
        -- print("hello world")
     -- end,
  -- })


  return C
end

function C.toggle()
  state.view_enabled = not state.view_enabled
end

C.statusline = "%!v:lua.DoStatusline()"

--- return the current task
---@return string
function C.view()
  return view.render(state)
end

function C.view_inactive()
  return view.render_inactive(state)
end

--- If there are currently tasks in the list
---@return boolean
function C.has_items()
  return state.tasks:count() > 0
end

function C.is_visible()
  return state.view_enabled and C.has_items()
end

return C
