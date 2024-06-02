local do_nvim = require("do")
local r = require;
P = function(v)
  print(vim.inspect(v))
  return v
end

--- add a todo to the list of todos
---@param todo_name string name of todo
---@param front boolean if todo should be added to front of list
local function add_todo(todo_name, front)
  if front then
    vim.cmd(":Do! " .. todo_name)
  else
    vim.cmd(":Do " .. todo_name)
  end
end

describe("Setup", function()
  it("should set up default values if no user config is provided", function()
    local state = r "do.state"
    local default_opts = state.default_options
    assert.are.same(state.init({}).options, default_opts)
  end)

  it("should use custom config when setup is called", function()
    local opts = {}
    r 'do'.setup({
      sources = { "do.sources.file" },
    })

    local state = require("do.state").get()
    assert.are.same(state.options.winbar, opts.winbar)
  end)
end)
