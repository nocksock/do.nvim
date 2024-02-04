local r = require

return {
  ---@param opts DoOptions
  setup = function(opts)
    R 'do.update'.clear()

    local state = r 'do.state'.init(opts)
    local o = state.options

    if o.register_command then
      r 'do.create_user_command' ()
    end

    if o.views then
      for _, view in ipairs(o.views) do
        r 'do.update'.subscribe(r(view))
      end
    end

    r 'do.update'.subscribe(r 'do.state'.set, false)

    if #o.sources > 0 then
      ---@param source DoSource
      for _, source in ipairs(o.sources) do
        local tasks = R(source).load(opts)
        r 'do.import' (tasks)
        r 'do.update'.subscribe(r(source).update)
      end
    else
      vim.notify("No persistence source for do.nvim defined. Data will be lost with session.", vim.log.levels.WARN)
    end
  end,

  ---@param action DoActionType
  ---@param args? string
  dispatch = function(action, args)
    r 'do.exec' ({ action = r('do.action.' .. action), args = args })
  end,


  add = function(todo)
    if type(todo) == 'table' then
      for _, t in ipairs(todo) do
        r 'do.exec' ({ action = r 'do.action.add', args = t })
      end
      return
    end

    if type(todo) == 'string' then
      r 'do.exec' ({ action = r 'do.action.add', args = todo })
      return
    end

    error("Invalid argument type for add")
  end,
}
