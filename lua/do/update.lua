local views = {}

local is_callable = function(fn_or_table)
  if type(fn_or_table) == 'function' then
    return true
  end

  local mt = getmetatable(fn_or_table)
  if mt == nil then
    return false
  end

  if type(mt.__call) == 'function' then
    return true
  end
end

local get_render_fn = function(view)
  if is_callable(view) then
    return view
  end

  if type(view) == 'table' and is_callable(view[1]) then
    return view[1]
  end
end

local get_clean_fn = function(view)
  if type(view) == 'table' and is_callable(view[2]) then
    return view[2]
  end
end

local remove = function(pred)
  for i, v in pairs(views) do
    if pred(v) then
      if type(v) == 'table' and type(v[2]) == 'function' then
        v[2]()
      end

      table.remove(views, i)
    end
  end
end

return setmetatable({
  subscribe = function(view, trigger)
    if not get_render_fn(view) then
      error("View is not callable. Needs to be a function or a table with a function as the first element.")
    end

    table.insert(views, view)

    if trigger ~= false then
      get_render_fn(view)(require 'do.state'.get())
    end
  end,

  unsubscribe = function(view)
    remove(function(sub) return view == sub end)
  end,

  clear = function()
    remove(function()
      return true
    end)
  end,
}, {
  __call = function(_, state)
    for _, v in pairs(views) do
      get_render_fn(v)(state)
    end
  end,
})
