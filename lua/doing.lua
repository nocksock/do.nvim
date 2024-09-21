-- A tinier task manager that helps you stay on track.
local create = vim.api.nvim_create_user_command
local core = require('doing.core')

_G.DoStatusline = core.view

create("Do", function(args)
  core.add(args.bang)
end, { nargs = 0, bang = true })

create("Done", core.done, {})

create("DoToggle", core.toggle_winbar, {})
create("DoHide", core.disable_winbar, {})
create("DoShow", core.enable_winbar, {})
create("DoEdit", core.edit, {})
create("DoSave", core.save, { bang = true })

return core
