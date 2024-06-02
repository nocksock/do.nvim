-- TODO: use todo_none in todo_fmt
return {
  ---@param todo DoTodo
  todo_fmt = function(todo)
    if not todo or todo.task == nil  then
      return "nothing to do"
    end
    return string.format("doing: %s", todo.task)
  end,
  todo_none = "nothing to do",
  message_done = function()
    local messages = {
      "Nice!",
      "Good job!",
      "Look at you go!",
      "You're on fire!",
      "You're doing great!",
      "Keep it up!",
      "This is the way!",
      "That's the spirit!",
    }
    return messages[math.random(#messages)]
  end,
  file_not_found = function(file_name)
    return string.format("file not found: %s", file_name)
  end,
}
