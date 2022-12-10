local C = {}
local kaomoji = require("do.kaomojis")
local view = require('do.view')
local edit = require('do.edit')
local store = require('do.store')
local state = require('do.state').state
local default_opts = require('do.state').default_opts
local utils = require('do.utils')

---Show a message for the duration of `options.message_timeout`
---@param str string Text to display
---@param hl? string Highlight group
function C.show_message(str, hl)
  state.message = "%#" .. (hl or "TablineSel") .. "#" .. str

  vim.defer_fn(function()
    state.message = nil
    C.redraw_winbar()
  end, default_opts.message_timeout)

  C.redraw_winbar()
end

---add a task to the list
---@param str string task to add
---@param to_front boolean whether to add task to front of list
function C.add(str, to_front)
  state.tasks:add(str, to_front)
  C.redraw_winbar()
  utils.exec_task_modified_autocmd()
end

--- Finish the first task
function C.done()
  if not state.tasks:has_items() then
    C.show_message(kaomoji.confused() .. " There was nothing left to do…", "InfoMsg")
    return
  end

  state.tasks:shift()

  if state.tasks:count() == 0 then
    C.show_message(kaomoji.joy() .. " ALL DONE! " .. kaomoji.joy(), "TablineSel")
  else
    C.show_message(kaomoji.joy() .. " Great! Only " .. state.tasks:count() .. " to go.", "MoreMsg")
  end

  utils.exec_task_modified_autocmd()
end

--- Edit the tasks in a floating window
function C.edit()
  edit.toggle_edit(state.tasks:get(), function(new_todos)
    state.tasks:set(new_todos)
    utils.exec_task_modified_autocmd()
  end)
end

--- save the tasks
function C.save()
  state.tasks:sync(true)
end

---Setup do.nvim
---@param opts DoOptions
function C.setup(opts)
  state.options = vim.tbl_deep_extend("force", default_opts, opts or {})
  state.tasks = store.init(state.options.store)
  local winbar_options = state.options.winbar

  -- @TODO: remove this on some future version
  if state.options.use_winbar then
    print("do.nvim: option `use_winbar` is deprecated. Use `winbar = { mode = 1 }`. See README for more.")
    winbar_options.enabled = true
  end

  C.setup_winbar(winbar_options)

  return C
end

---configure displaying current to do item in winbar
---@param options WinbarOptions|boolean
function C.setup_winbar(options)
  options = utils.parse_winbar_options(options)

  if not options then
    return
  end

  vim.g.winbar = view.stl_nc
  vim.api.nvim_win_set_option(0, "winbar", view.stl)

  state.auGroupID = vim.api.nvim_create_augroup("do_nvim", { clear = true })

  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = state.auGroupID,
    callback = function()
      C.redraw_winbar()
    end
  })

  -- winbar should not be displayed in windows the cursor is not in
  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = state.auGroupID,
    callback = function()
      C.redraw_winbar()
    end
  })
end

function C.disable_winbar()
  if not state.auGroupID then
    return -- already disabled
  end

  for _, value in ipairs(vim.api.nvim_list_wins()) do
    if vim.fn.win_gettype() == "" then
      vim.api.nvim_win_set_option(value, "winbar", nil)
    end
  end

  vim.api.nvim_del_augroup_by_id(state.auGroupID)
  C.hide()
end

function C.enable_winbar()
  C.setup_winbar(state.options.winbar)
end

--- toggle the visibility of the winbar
function C.toggle_winbar()
  -- disable winbar completely when not visible
  vim.wo.winbar = vim.wo.winbar == "" and view.stl or ""
  state.view_enabled = not state.view_enabled
end

function C.view(variant)
  if variant == 'active' then
    return view.render(state)
  end

  if variant == 'inactive' then
    return view.render_inactive(state)
  end
end

---for things like lualine
function C.view_inactive()
  return view.render_inactive(state)
end

function C.is_visible()
  return state.view_enabled and state.tasks:has_items()
end

function C.has_message()
  return not not state.message
end

function C.hide()
  vim.wo.winbar = ""

  vim.cmd([[
    set winbar=
    redrawstatus
  ]])
end

--- Redraw winbar depending on if there are tasks. Redraw if there are pending tasks, other wise set to ""
function C.redraw_winbar()
  if not utils.parse_winbar_options(state.options.winbar) then
    return
  end

  if utils.can_have_winbar() then
    if state.tasks:has_items() or C.has_message() then
      vim.wo.winbar = view.stl
    else
      C.hide()
    end
  end
end

return C
