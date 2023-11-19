local r = require

return {
  ---@param opts DoOptions
  setup = function(opts)
    R'do.update'.clear()

    local state = r'do.state'.init(opts)
    local o = state.options

    if o.register_command then
      r'do.create_user_command'()
    end

    if o.views then
      for _, view in ipairs(o.views) do
        r'do.update'.subscribe(view)
      end
    end

    r'do.update'.subscribe(r'do.state'.set, false)
    if o.source then
      for _, view in ipairs(o.source) do
        r'do.update'.subscribe(view)
      end
    else
      vim.notify("No persistence source for do.nvim defined. Data will be lost with session.", vim.log.levels.WARN)
    end
  end,

  add = function(todo)
    r'do.exec'({
      action = r'do.actions.add',
      args = todo
    })
  end,
}
