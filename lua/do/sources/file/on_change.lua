local r = require
---@type DoSourceFileOptions
return function(opts)
  local augroup = vim.api.nvim_create_augroup("do.file", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = opts.file_name,
    group = augroup,
    callback = function()
      local state = r 'do.sources.file.parse' (opts.file_name)
      r 'do.state'.set(state)
    end
  })
end
