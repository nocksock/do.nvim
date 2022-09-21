local state = require("do.state").state
local utils = require("do.utils")
-- print("core:", vim.inspect(core)) -- __AUTO_GENERATED_PRINT_VAR__
local global_win = nil
local global_buf = nil
local M = {}

local function open_float()
  local bufnr = vim.api.nvim_create_buf(false, false)
  local width = math.min(vim.opt.columns:get(), 60)
  local height = math.min(vim.opt.lines:get(), 10)
  local win = vim.api.nvim_open_win(bufnr, true, {
    relative = "win",
    border = "rounded",
    noautocmd = true,
    col = vim.opt.columns:get()/2 - width/2,
    row = vim.opt.lines:get()/2 - height/2,
    width = width,
    height = height
  })

  vim.api.nvim_win_set_option(win, "winhl", "Normal:NormalFloat")

  return {
    buf = bufnr,
    win = win
  }
end --

local function get_buf_tasks()
  local lines = vim.api.nvim_buf_get_lines(global_buf, 0, -1, true)
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

  vim.api.nvim_win_close(global_win, true)
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

  vim.api.nvim_win_set_option(global_win, "number", true)
  vim.api.nvim_buf_set_option(global_buf, "swapfile", false)
  vim.api.nvim_buf_set_option(global_buf, "filetype", "do_tasks")
  vim.api.nvim_buf_set_option(global_buf, "buftype", "acwrite")
  vim.api.nvim_buf_set_option(global_buf, "bufhidden", "delete")
  vim.api.nvim_buf_set_name(global_buf, "do-edit")
  vim.api.nvim_buf_set_lines(global_buf, 0, #tasks, false, tasks)

  vim.keymap.set("n", "q", function()
    M.close(cb)
  end, { buffer = global_buf })

  -- local group = vim.api.nvim_create_augroup("do_nvim", { clear = true })

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    group = state.auGroupId,
    buffer = global_buf,
    callback = function()
      M.close(cb)
    end
  })

  vim.api.nvim_create_autocmd("BufModifiedSet", {
    group = state.auGroupId,
    buffer = global_buf,
    callback = function()
      vim.api.nvim_buf_set_option(global_buf, "modified", false)
    end
  })
end

return M
