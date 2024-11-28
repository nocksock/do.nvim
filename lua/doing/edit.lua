local utils = require("doing.utils")
-- print("core:", vim.inspect(core)) -- __AUTO_GENERATED_PRINT_VAR__
local global_win = nil
local global_buf = nil
local state = require("doing.state")
local M = {}

local function open_float()
  local bufnr = vim.api.nvim_create_buf(false, false)
  local width = math.min(vim.opt.columns:get(), 80)
  local height = math.min(vim.opt.lines:get(), 12)
  local win = vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    border = "rounded",
    noautocmd = false,
    col = vim.opt.columns:get() / 2 - width / 2,
    row = vim.opt.lines:get() / 2 - height / 2,
    width = width,
    height = height
  })

  -- vim.api.nvim_win_set_option(win, "winhl", "Normal:NormalFloat")
  vim.api.nvim_set_option_value("winhl", "Normal:NormalFloat", {})

  return {
    buf = bufnr,
    win = win
  }
end --

--- Get all the tasks currently in the pop up window
---@return string[]
local function get_buf_tasks()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local indices = {}

  for _, line in pairs(lines) do
    if not utils.is_white_space(line) then
      table.insert(indices, line)
    end
  end

  return indices
end

function M.close(cb)
  if cb then
    cb(get_buf_tasks())
  end

  vim.api.nvim_win_close(0, true)
  global_win = nil
  global_buf = nil
end

function M.toggle_edit(tasks, cb)
  if global_win ~= nil and vim.api.nvim_win_is_valid(global_win) then
    M.close()
    return
  end

  local win_info = open_float()
  global_win = win_info.win
  global_buf = win_info.buf

  vim.api.nvim_set_option_value("number", true, {})
  vim.api.nvim_set_option_value("swapfile", false, {})
  vim.api.nvim_set_option_value("filetype", "doing_tasks", {})
  vim.api.nvim_set_option_value("buftype", "acwrite", {})
  vim.api.nvim_set_option_value("bufhidden", "delete", {})
  vim.api.nvim_buf_set_name(global_buf, "do-edit")
  vim.api.nvim_buf_set_lines(global_buf, 0, #tasks, false, tasks)

  vim.keymap.set("n", "q", function()
    M.close(cb)
  end, { buffer = global_buf })
  vim.keymap.set("n", "<Esc>", function()
    M.close(cb)
  end, { buffer = global_buf })

  -- event after tasks from pop up has been written to
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    group = state.state.auGroupID,
    buffer = global_buf,
    callback = function()
      local new_todos = get_buf_tasks()
      state.state.tasks:set(new_todos)
    end
  })

  vim.api.nvim_create_autocmd("BufModifiedSet", {
    group = state.state.auGroupID,
    buffer = global_buf,
    callback = function()
      vim.api.nvim_set_option_value("modified", false, {})
    end
  })
end

return M
