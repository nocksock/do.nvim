local r = require
local assert = r 'luassert'
local stub  = require 'luassert.stub'
local t = require'do.text'

describe('do.nvim', function()
  after_each(function()
    vim.o.winbar = ""
  end)

  it('can add todos with :Do', function()
    require 'do'.setup {}

    vim.cmd("Do! add a todo")
    vim.cmd("Do! add another todo")

    assert.are.same({ "a todo", "another todo" }, require 'do.state'.get().todos)
    assert.are.same("doing: a todo", vim.o.winbar)
  end)

  -- it('calls winbars cleanup on setup', function()
  --   local view = { stub(), stub() }
  --   package.loaded['do.views.winbar'] = view
  --   require 'do'.setup()
  --   assert.stub(view[2]).was.called(1)
  -- end)

  it('sets current_todo on add if nil', function()
    require 'do'.setup()
    assert.are.same(t.todo_none, vim.o.winbar)
    vim.cmd("Do! add a todo")
    vim.cmd("Do! add another todo")
    assert.are.same({ "a todo", "another todo" }, require 'do.state'.get().todos)
    assert.are.same(t.todo_fmt("a todo"), vim.o.winbar)
  end)

end)
