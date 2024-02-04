return function(file_name)
  local f = io.open(file_name, "w")
  assert(f, "couldn't create " .. file_name)
  f:write("")
  f:close()
  return file_name
end

