local r = require

---@class DoSourceFileOptions
---@field file_name string
---@field task_prefix {todo: string, done: string}
local default_options = {
  file_name = 'todos.do',
  task_prefix = {
    todo = "-",
    done = "x"
  }
}

local opts = nil
local file = nil

---@type DoSource
return {
  opts = opts,
  ---@param opts? DoSourceFileOptions
  load = function(input_opts)
    opts = vim.tbl_extend("force", default_options, input_opts)
    file = r 'do.sources.file.find' (opts.file_name)

    r 'lua.do.sources.file.setup_autocmd' (opts)

    if file == nil then
      file = r 'do.source.file.create' (opts.file_name)
    end

    return r 'do.sources.file.parse' (vim.fn.readfile(file))
  end,

  ---@param state DoState
  save = function(state)
    local file_content = r 'do.sources.file.serialize' (state);

    if not file then
      error("No file loaded")
    end

    if not vim.fn.filewritable(file) then
      error(string.format("Cannot write file %s", file))
    end

    vim.fn.writefile(file_content, file)
  end,
}
