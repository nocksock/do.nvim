--- @class DoTodo
local todo = {
  task = "",
  done = false,

  ref = "", -- reference to where the task was created
  source = "", -- TODO: use a generic here
  meta = {} -- for sources to store their own data
}

return todo
