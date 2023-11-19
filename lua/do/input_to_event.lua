--- @enum DoActionType
local actions = {
  "add", "done", "now", "later", "skip", "list", "select"
}

---@param opts { fargs?: {} }
--- @return DoEvent | nil
return function(opts)
  local fargs = opts.fargs or {}

  if not fargs[1] or fargs == nil then
    error("No command given")
    return nil
  end

  -- `:Do` falls back to "add" when first argument is not a command
  if not string.match(fargs[1], "^%.") then
    table.insert(fargs, 1, ".add")
  end

  local action_name = fargs[1]:gsub("^%.", "")
  if not vim.tbl_contains(actions, action_name) then
    print("Invalid command: " .. action_name)
    print("Available commands: " .. table.concat(actions, ", "))
    return nil
  end

  if type(action_name) ~= "string" then
    error("Command must be a string")
  end

  table.remove(fargs, 1)

  return {
    action = require('do.action.' .. action_name),
    args = table.concat(fargs, " ")
  }
end
