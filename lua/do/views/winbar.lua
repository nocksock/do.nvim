local t = require 'do.text'

return {
  ---@param state DoState
  function(state)
    local current_todo = require 'do.select.current_todo' (state)

    if current_todo then
      vim.o.winbar = t.todo_fmt(current_todo)
    else
      vim.o.winbar = t.todo_none
    end
  end,
  function()
    print("unmount")
    vim.o.winbar = " "
  end
}
