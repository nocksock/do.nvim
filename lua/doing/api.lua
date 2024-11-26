local Api = {}

local view = require("doing.view")
local state = require("doing.state").state
local core  = require('doing.core')
local utils = require("doing.utils")

---Create a status string for the current task
---@return string|table
function Api.status()
  return view.render()
end

---add a task to the list
---@param str string task to add
---@param to_front boolean whether to add task to front of list
function Api.add(str, to_front)
    state.tasks:add(str, to_front)
    core.redraw_winbar()
    utils.exec_task_modified_autocmd()
end

---edit the tasks in a floating window
function Api.edit()
  core.edit()
end

---finish the first task
function Api.done()
  core.done()
end

return Api
