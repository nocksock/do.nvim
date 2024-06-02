local r      = require
local assert = r 'luassert'
local stub   = require 'luassert.stub'
local t      = require 'do.text'

local todos  = {}

describe('do.nvim', function()
  before_each(function()
    R 'do'.setup({
      sources = {
        load = function() return {} end,
        update = function(state) todos = state.todos end
      }
    })
  end)

  after_each(function()
    vim.o.winbar = ""
  end)

  it('can add todos with :Do', function()
    vim.cmd("Do .add a todo")
    vim.cmd("Do .add another todo")

    assert.are.same({
      {
        task = "a todo",
        done = false
      },
      {

        task = "another todo",
        done = false,
      }
    }, r 'do.state'.get().todos)

    assert.are.same("doing: a todo", vim.o.winbar)
  end)

  it('sets current_todo on add if nil', function()
    assert.are.same(t.todo_none, vim.o.winbar)
    vim.cmd("Do a todo")
    vim.cmd("Do another todo")
    assert.are.same({
      { task = "a todo",       done = false },
      { task = "another todo", done = false }
    }, require 'do.state'.get().todos)
    assert.are.same(t.todo_fmt({
      task = "a todo",
      done = false
    }), vim.o.winbar)
  end)
end)
