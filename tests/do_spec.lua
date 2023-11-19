local do_nvim = require("do")

--- Get the list of current todos from `:DoEdit`
---@return string[]
local function get_todo_list()
	vim.cmd(":DoEdit")
	-- get all the todos in the buffer
	local todos = vim.api.nvim_buf_get_lines(0, 0, 100, false)
	vim.cmd(":q!")
	return todos
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
		local state = require("do.state").state
		local default_opts = require("do.state").default_opts
		do_nvim.setup({})
		assert.are.same(state.options, default_opts)
	end)

	it("should use custom config when setup is called", function()
		local state = require("do.state").state
		local opts = {
			message_timeout = 2000, -- how long notifications are shown
			kaomoji_mode = 0, -- 0 kaomoji everywhere, 1 skip kaomoji in doing
			doing_prefix = "xxx: ",
			winbar = true,
			store = {
				auto_create_file = false, -- automatically create a .do_todos when calling :Do
				file_name = ".do_todossss",
			},
		}
		do_nvim.setup(opts)

		assert.are.same(state.options.message_timeout, opts.message_timeout)
		assert.are.same(state.options.kaomoji_mode, opts.kaomoji_mode)
		assert.are.same(state.options.doing_prefix, opts.doing_prefix)
		assert.are.same(state.options.winbar, opts.winbar)
		assert.are.same(state.options.store.auto_create_file, opts.store.auto_create_file)
		assert.are.same(state.options.store.file_name, opts.store.file_name)
	end)
end)

describe(":Do!", function()
	it("should add a todo to an empty todo list", function()
		local todo_name = "test todo"
		vim.cmd(":Do! " .. todo_name)

		local todos = get_todo_list()
		-- check if our todo is among the todos stored
		assert.are.equals(vim.tbl_contains(todos, todo_name), true)
	end)

	it("should add a todo to the beginning of the list", function()
		local todos = {
			"test1",
			"test2",
			"test3",
			"test4",
		}
		local todo_name = "new todo"

		vim.cmd(":Done!")

		-- add a series of todos
		for _, todo in ipairs(todos) do
			vim.cmd(":Do! " .. todo)
		end

		vim.cmd(":Do! " .. todo_name)

		local current_todos = get_todo_list()
		assert.are.equals(current_todos[1], todo_name)

      -- clean up
		for _, _ in ipairs(todos) do
			vim.cmd(":Done!")
		end
	end)

	it("should add a todo to the end of the list", function()
		local todos = {
			"test1",
			"test2",
			"test3",
			"test4",
		}
		local todo_name = "new todo"

		vim.cmd(":Done!")

		-- add a series of todos
		for _, todo in ipairs(todos) do
			add_todo(todo, true)
		end

		add_todo(todo_name, false)
		local current_todos = get_todo_list()
		-- check if the last todo is the one we expect
		assert.are.equals(current_todos[#current_todos], todo_name)
	end)
end)

P = function(v)
  print(vim.inspect(v))
  return v
end

describe("winbar", function()
  it("should only show the active one once", function ()
		add_todo("testing todo", true)

    vim.cmd('normal iFirst buffer')
    vim.cmd('new test')
    vim.cmd('normal iSecond buffer')

    local buffer_a = vim.api.nvim_get_option_value("winbar", {  buf = 1 })
    local buffer_b = vim.api.nvim_get_option_value("winbar", {  buf = 4 })

		assert.are.equal(buffer_a, "%!v:lua.DoStatusline('inactive')")
		assert.are.equal(buffer_b, "%!v:lua.DoStatusline('active')")
  end)

	it("should show the current todo name with only 1 todo in the list", function()
		add_todo("test", true)
		local winbar_value = vim.api.nvim_get_option_value("winbar", { scope = "local" })
		assert.are.equal(winbar_value, "%!v:lua.DoStatusline('active')")
	end)
end)
