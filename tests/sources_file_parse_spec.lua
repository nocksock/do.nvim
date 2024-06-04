local r      = require
local assert = r 'luassert'
local stub   = require 'luassert.stub'
local t      = require 'do.text'

local todos  = {}

local todo   = function(task)
  return { task = task, done = false, source = "do.sources.file" }
end
local done   = function(task)
  return { task = task, done = true, source = "do.sources.file" }
end

describe('sources.file.parse.parse_line', function()
  it('creates a list of DoTodo[]', function()
    ---@type DoSourceFileOptions
    local opts = {
      file_name = "todo.do",
      task_prefix = {
        todo = "- ",
        done = "x "
      }
    }
    local parse = r 'do.sources.file.parse'
    local tests = {
      { "- foobar", todo("foobar") },
      { "foobar",   todo("foobar") },
      { "x foobar", done("foobar") },
    }
    for _, test in ipairs(tests) do
      assert.are.same(test[2], parse.line(test[1], opts))
    end
  end)
end)
