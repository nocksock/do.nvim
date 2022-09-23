local do_nvim = require("do")

--- Get the list of current tasks from `:DoEdit`
---@return string[]
local function get_task_list()
	vim.cmd(":DoEdit")
	-- get all the tasks in the buffer
	local tasks = vim.api.nvim_buf_get_lines(0, 0, 100, false)
	print("get_task_list tasks:", vim.inspect(tasks)) -- __AUTO_GENERATED_PRINT_VAR__
	vim.cmd(":q!")
	return tasks
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
			use_winbar = true,
			store = {
				auto_create_file = false, -- automatically create a .do_tasks when calling :Do
				file_name = ".do_taskssss",
			},
		}
		do_nvim.setup(opts)

		assert.are.same(state.options.message_timeout, opts.message_timeout)
		assert.are.same(state.options.kaomoji_mode, opts.kaomoji_mode)
		assert.are.same(state.options.doing_prefix, opts.doing_prefix)
		assert.are.same(state.options.use_winbar, opts.use_winbar)
		assert.are.same(state.options.store.auto_create_file, opts.store.auto_create_file)
		assert.are.same(state.options.store.file_name, opts.store.file_name)
	end)
end)

describe(":Do!", function()
	it("should add a task to an empty task list", function()
		local task_name = "test task"
		vim.cmd(":Do! " .. task_name)

		local tasks = get_task_list()
		-- check if our task is among the tasks stored
		assert.are.equals(vim.tbl_contains(tasks, task_name), true)
	end)

	it("should add a task to the beginning of the list", function()
		local tasks = {
			"test1",
			"test2",
			"test3",
			"test4",
		}
		local task_name = "new task"

		vim.cmd(":Done!")

		-- add a series of tasks
		for _, task in ipairs(tasks) do
			vim.cmd(":Do! " .. task)
		end

		vim.cmd(":Do! " .. task_name)

		local current_tasks = get_task_list()
		assert.are.equals(current_tasks[1], task_name)
	end)

	it("should add a task to the end of the list", function()
		local tasks = {
			"test1",
			"test2",
			"test3",
			"test4",
		}
		local task_name = "new task"

		vim.cmd(":Done!")

		-- add a series of tasks
		for _, task in ipairs(tasks) do
			vim.cmd(":Do! " .. task)
		end

		vim.cmd(":Do " .. task_name)

		local current_tasks = get_task_list()
		-- check if the last task is the one we expect
		assert.are.equals(current_tasks[#current_tasks], task_name)
	end)
end)
