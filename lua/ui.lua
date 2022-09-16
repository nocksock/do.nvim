local popup = require("plenary.popup")
local utils = require("utils")

local M = {}

Do_win_id = nil
Do_bufh = nil

local function create_window()
  local width = 60
  local height = 10
  local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
  local bufnr = vim.api.nvim_create_buf(false, false)

  local Do_win_id, win = popup.create(bufnr, {
    title = "Do",
    highlight = "DoWindow",
    line = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = borderchars,
  })

  vim.api.nvim_win_set_option(
    win.border.win_id,
    "winhl",
    "Normal:DoBorder"
  )

  return {
    bufnr = bufnr,
    win_id = Do_win_id,
  }
end

local function get_buf_tasks()
  local lines = vim.api.nvim_buf_get_lines(Do_bufh, 0, -1, true)
  local indices = {}

  for _, line in pairs(lines) do
    if not utils.is_white_space(line) then
      table.insert(indices, line)
    end
  end

  return indices
end

local function close_menu(cb)
  if cb then
    cb(get_buf_tasks())
  end

  vim.api.nvim_win_close(Do_win_id, true)
  Do_win_id = nil
  Do_bufh = nil
end

function M.toggle_edit(tasks, cb)
  if Do_win_id ~= nil and vim.api.nvim_win_is_valid(Do_win_id) then
    close_menu()
    return
  end

  local win_info = create_window()
  local contents = tasks

  Do_win_id = win_info.win_id
  Do_bufh = win_info.bufnr

  vim.api.nvim_win_set_option(Do_win_id, "number", true)
  vim.api.nvim_buf_set_option(Do_bufh, "swapfile", false)
  vim.api.nvim_buf_set_option(Do_bufh, "filetype", "doing")
  vim.api.nvim_buf_set_option(Do_bufh, "buftype", "acwrite")
  vim.api.nvim_buf_set_option(Do_bufh, "bufhidden", "delete")
  vim.api.nvim_buf_set_name(Do_bufh, "do-menu")
  vim.api.nvim_buf_set_lines(Do_bufh, 0, #contents, false, contents)

  vim.keymap.set("n", "q", function()
    close_menu(cb)
  end, { buffer = Do_bufh })

  local group = vim.api.nvim_create_augroup("do_nvim", { clear = true })

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    group = group,
    buffer = Do_bufh,
    callback = function()
      close_menu(cb)
    end
  })

  vim.api.nvim_create_autocmd("BufModifiedSet", {
    group = group,
    buffer = Do_bufh,
    callback = function()
      vim.api.nvim_buf_set_option(Do_bufh, "modified", false)
    end
  })
end

function M.location_window(options)
  local default_options = {
    relative = "editor",
    style = "minimal",
    width = 30,
    height = 15,
    row = 2,
    col = 2,
  }
  options = vim.tbl_extend("keep", options, default_options)

  local bufnr = options.bufnr or vim.api.nvim_create_buf(false, true)
  local win_id = vim.api.nvim_open_win(bufnr, true, options)

  return {
    bufnr = bufnr,
    win_id = win_id,
  }
end

return M
