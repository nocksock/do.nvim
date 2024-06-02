local r = require

---@class DoSetup : table
---@field setup fun(opts: DoOptions)
return {
  setup = function(opts)
    R 'do.state'.clear()

    local state = r 'do.state'.init(opts)
    local o = state.options

    if o.register_command then
      r 'do.create_user_command' ()
    end

    if o.views then
      for _, view in ipairs(o.views) do
        if type(view) == 'string' then
          view = r(view)
        end
        r 'do.state'.subscribe(view)
      end
    end

    if #o.sources > 0 then
      ---@param source DoSource
      for _, source in ipairs(o.sources) do
        if type(source) == 'string' then
          source = r(source)
        end

        local tasks = source.load(opts)
        r 'do.import' (tasks)
        r 'do.state'.subscribe(source.save)
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
