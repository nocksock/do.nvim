local data = {}

return {
  add = function(item) table.insert(data, item) end,
  get_all = function() return data end,
  size = function() return #data end,
  clear = function() data = {} end,
}
