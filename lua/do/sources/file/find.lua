---@param file_name string
return function(file_name)
  local file = vim.fn.findfile(file_name, ".;")

  if file == nil or file == "" then
    local should_create_file = vim.cmd.exec { "input('create? Y/n')" }
    if should_create_file == "n" then
      return nil
    end
    return require 'do.sources.file.create' (file_name)
  end

  local is_readable = vim.fn.filereadable(file) == 1
  assert(is_readable, string.format("file not readable: %s", file))

  return file
end
