local C = {}
local kaomoji = require("do.kaomojis")
local view = require('do.view')
local edit = require('do.edit')
local store = require('do.store')
local state = require('do.state').state
local default_opts = require('do.state').default_opts
local utils = require('do.utils')

local augroup = vim.api.nvim_create_augroup("do_nvim", { clear = true })

---Show a message for the duration of `options.message_timeout`
---@param str string Text to display
---@param hl? string Highlight group
function C.show_message(str, hl)
  state.message = "%#" .. (hl or "TablineSel") .. "#" .. str

  vim.defer_fn(function()
    state.message = nil
  end, default_opts.message_timeout)
end

---@param str string
---@param to_front boolean
function C.add(str, to_front)
  state.tasks:add(str, to_front)
  utils.redraw_winbar()
end

--- Finish the first task
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
  utils.redraw_winbar()
end

--- Edit the tasks in a floating window
function C.edit()
  edit.toggle_edit(state.tasks:get(), function(new_todos)
    state.tasks:set(new_todos)
  end)
end

--- save the tasks
function C.save()
  state.tasks:sync(true)
  utils.redraw_winbar()
end

---@param opts DoOptions
function C.setup(opts)
  state.options = vim.tbl_deep_extend("force", default_opts, opts or {})
  state.tasks = store.init(state.options.store)

  if state.options.use_winbar then
    C.setup_winbar()
  end

  return C
end

--- configure displaying current to do item in winbar
function C.setup_winbar()
  -- vim.o.winbar = view.stl
  vim.o.winbar = nil
  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = augroup,
    callback = function()
       utils.redraw_winbar()
    end
  })

  -- winbar should not be displayed in windows the cursor is not in
  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = augroup,
    callback = function()
       vim.wo.winbar = ""
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

function C.has_items()
  return state.tasks:count() > 0
end

function C.is_visible()
  return state.view_enabled and C.has_items()
end

return C
