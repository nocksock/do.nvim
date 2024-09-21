local Core = {}
local view = require("doing.view")
local edit = require("doing.edit")
local store = require("doing.store")
local state = require("doing.state").state
local default_opts = require("doing.state").default_opts
local utils = require("doing.utils")

---Show a message for the duration of `options.message_timeout`
---@param str string Text to display
function Core.show_message(str)
  state.message = str

  vim.defer_fn(function()
    state.message = nil
    Core.redraw_winbar()
  end, default_opts.message_timeout)

  Core.redraw_winbar()
end

---add a task to the list
---@param to_front boolean whether to add task to front of list
function Core.add(to_front)
  state.tasks:sync(true)
  vim.ui.input({ prompt = 'Enter the new task: ' }, function(input)
    state.tasks:add(input, to_front)
    Core.redraw_winbar()
    utils.exec_task_modified_autocmd()
  end)
end

--- Finish the first task
function Core.done()
  if not state.tasks:has_items() then
    Core.show_message(" There was nothing left to do ")
    return
  end

  state.tasks:shift()

  if state.tasks:count() == 0 then
    Core.show_message(" All tasks done ")
  else
    Core.show_message(state.tasks:count() .. " left.")
  end

  utils.exec_task_modified_autocmd()
end

--- Edit the tasks in a floating window
function Core.edit()
  edit.toggle_edit(state.tasks:get(), function(new_todos)
    state.tasks:set(new_todos)
    utils.exec_task_modified_autocmd()
  end)
  state.tasks:sync(true)
  Core.redraw_winbar()
end

--- save the tasks
function Core.save()
  state.tasks:sync(true)
end

---Setup doing.nvim
---@param opts DoOptions
function Core.setup(opts)
  state.options = vim.tbl_deep_extend("force", default_opts, opts or {})
  state.tasks = store.init(state.options.store)
  local winbar_options = state.options.winbar

  Core.setup_winbar(winbar_options)

  return Core
end

---configure displaying current to do item in winbar
---@param options WinbarOptions|boolean
function Core.setup_winbar(options)
  options = utils.parse_winbar_options(options)

  if not options then
    return
  end

  vim.g.winbar = view.stl_nc
  vim.api.nvim_set_option_value("winbar", view.stl, {})

  state.auGroupID = vim.api.nvim_create_augroup("doing_nvim", { clear = true })

  -- winbar should not be displayed in windows the cursor is not in
  vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave", "BufEnter", "BufLeave" }, {
    group = state.auGroupID,
    callback = function()
      Core.redraw_winbar()
    end,
  })
end

function Core.disable_winbar()
  if not state.auGroupID then
    return -- already disabled
  end

  for _, _ in ipairs(vim.api.nvim_list_wins()) do
    if vim.fn.win_gettype() == "" then
      vim.api.nvim_set_option_value("winbar", nil, {})
    end
  end

  vim.api.nvim_del_augroup_by_id(state.auGroupID)
  Core.hide()
end

function Core.enable_winbar()
  Core.setup_winbar(state.options.winbar)
end

--- toggle the visibility of the winbar
function Core.toggle_winbar()
  -- disable winbar completely when not visible
  vim.wo.winbar = vim.wo.winbar == "" and view.stl or ""
  state.view_enabled = not state.view_enabled
end

function Core.view(variant)
  state.tasks = store.init(state.options.store)

  if variant == "active" then
    return view.render(state)
  end

  if variant == "inactive" then
    return view.render_inactive(state)
  end
end

---for things like lualine
function Core.view_inactive()
  state.tasks = store.init(state.options.store)

  return view.render_inactive(state)
end

function Core.is_visible()
  return state.view_enabled and state.tasks:has_items()
end

function Core.has_message()
  return not not state.message
end

function Core.hide()
  vim.wo.winbar = ""

  vim.cmd([[ set winbar= ]])
  vim.cmd([[ redrawstatus ]])
end

--- Redraw winbar depending on if there are tasks. Redraw if there are pending tasks, other wise set to ""
function Core.redraw_winbar()
  if not utils.parse_winbar_options(state.options.winbar) then
    return
  end

  if utils.can_have_winbar() then
    if state.tasks:has_items() or Core.has_message() then
      vim.wo.winbar = view.stl
    else
      Core.hide()
    end
  end
end

return Core
