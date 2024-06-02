local r = require
---@type DoSourceFileOptions
return function(opts)
  local augroup = vim.api.nvim_create_augroup("do.file", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = opts.file_name,
    group = augroup,
    callback = function(args)
      local content = vim.api.nvim_buf_get_lines(args.buf, 1, -1, false)
      r 'do.state'.set({ todos = r 'do.sources.file.parse' (content) })
    end
  })
end
