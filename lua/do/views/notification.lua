---@param state DoState
return function(state)
  if state.message then
    vim.notify(state.message, vim.log.levels.INFO)
  end
end

