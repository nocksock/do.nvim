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
  end, default_opts.message_timeout)
end

---add a task to the list
---@param str string task to add
---@param to_front boolean whether to add task to front of list
function C.add(str, to_front)
  state.tasks:add(str, to_front)
end

--- Finish the first task
function C.done()
  if state.tasks:count() == 0 then
    C.show_message(kaomoji.confused() .. " There was nothing left to do…", "InfoMsg")
    utils.exec_task_modified_autocmd()
    return
  end

  state.tasks:shift()

  if state.tasks:count() == 0 then
    C.show_message(kaomoji.joy() .. " ALL DONE! " .. kaomoji.joy(), "TablineSel")
  else
    C.show_message(kaomoji.joy() .. " Great! Only " .. state.tasks:count() .. " to go.", "MoreMsg")
  end
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
  state.auGroupID = vim.api.nvim_create_augroup("do_nvim", { clear = true })
  local winbar_options = state.options.winbar

  -- @TODO: remove this on some future version
  if state.options.use_winbar then
    print("do.nvim: option `use_winbar` is deprecated. Use `winbar = { mode = 1 }`. See README for more.")
    winbar_options.enabled = true
  end


  if type(winbar_options) == "boolean" then
    C.setup_winbar({ enabled = winbar_options })
  else
    C.setup_winbar(winbar_options)
  end


  return C
end

---configure displaying current to do item in winbar
---@param options WinbarOptions
function C.setup_winbar(options)
  if not options.enabled then
    return
  end

  vim.o.winbar = view.stl_nc
  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = state.auGroupID,
    callback = function()
      if vim.fn.win_gettype() == "" and vim.bo.buftype ~= "prompt" then
        vim.opt_local.winbar = view.stl
      end
    end
  })

  -- winbar should not be displayed in windows the cursor is not in
  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = state.auGroupID,
    callback = function()
      if vim.fn.win_gettype() == "" and vim.bo.buftype ~= "prompt" then
        vim.opt_local.winbar = view.stl_nc
      end
    end
  })
end

--- toggle the visibility of the winbar
function C.toggle()
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

---If there are currently tasks in the list
---@return boolean
function C.has_items()
  return state.tasks:count() > 0
end

function C.is_visible()
  return state.view_enabled and C.has_items()
end

return C
