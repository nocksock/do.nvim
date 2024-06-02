local t = require 'do.text'

return {
  ---@param state DoState
  function(state)
    local current_todo = require 'do.select.current_todo' (state)
    local augroup = vim.api.nvim_create_augroup("do.nvim", { clear = true })

    local current_win = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if win == current_win then
        vim.api.nvim_win_set_option(win, "winbar", t.todo_fmt(current_todo))
      else
        vim.api.nvim_win_set_option(win, "winbar", " ")
      end
    end

    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
      group = augroup,
      callback = function()
        pcall(function()
          if current_todo then
            vim.o.winbar = t.todo_fmt(current_todo)
          else
            vim.o.winbar = t.todo_none
          end
        end)
      end
    })

    -- winbar should not be displayed in windows the cursor is not in
    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
      group = augroup,
      callback = function()
        pcall(function()
          vim.o.winbar = " "
        end)
      end
    })
  end,
  function()
    print("unmount")
    vim.o.winbar = " "
  end
}
