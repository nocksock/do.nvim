local r = require

return function()
  vim.api.nvim_create_user_command("Do", r'do.compose'(
    r'do.input_to_event',
    r'do.exec'
  ), { nargs = '+', bang = true })
end
