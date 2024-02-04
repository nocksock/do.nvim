local r = require

return function()
  vim.api.nvim_create_user_command("Do", function(opts)
    r'do.exec'(r'do.input_to_event'(opts))
  end, { nargs = '+', bang = true })

  vim.api.nvim_create_user_command("Done", function()
    r'do'.dispatch("done")
  end, { bang = true })

  vim.api.nvim_create_user_command("DoSelect", function()
    r'do'.dispatch("select")
  end, {})

  vim.api.nvim_create_user_command("DoInfo", function()
    r'do'.dispatch("info")
  end, {})
end
