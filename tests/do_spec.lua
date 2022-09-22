local do_nvim = require("do")
describe("Setup", function()
	it("should set up default values if no user config is provided", function()
		local state = require("do.state").state
		local default_opts = require("do.state").default_opts
		do_nvim.setup({})
		assert.are.same(state.options, default_opts)
	end)

	it("should use custom config when setup is called", function()
		local state = require("do.state").state
		local default_opts = require("do.state").default_opts
		local opts = {
			-- default options
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
