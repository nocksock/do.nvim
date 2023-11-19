local function compose(...)
  local last_result = nil
  local functions = {...}

  return function(...)
    for _, func in ipairs(functions) do
      last_result = func(last_result or ...)
    end
    return last_result
  end
end

return compose
