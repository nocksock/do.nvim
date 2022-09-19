--
--        ....
--    .xH888888Hx.
--  .W8888888888888.           u.
--  888*"""?""*88888X    ...ue888b
-- 'f     d8x.   ^%88k   888R Y888r
-- '>    <88888X   '?8   888R I888>
--  `:..:`888888>    8>  888R I888>
--         `"*88     X   888R I888>
--    .xHHhx.."      !  u8888cJ888
--   X88888888hx. ..!    "*888*P"
--  !   "*888888888"       'Y"
--         ^"***"`
--
--
-- A tiny task manager that helps you stay on track.
--
local create = vim.api.nvim_create_user_command
local kaomoji = require("do.kaomojis")
local core = require('do.core')

_G.DoStatusline = core.view

create("Do", function(args)
  core.add(args.args, args.bang)
end, { nargs = 1, bang = true })

create("Done", function(args)
  -- not sure if I like this. 
  if not args.bang then
    core.show_message(kaomoji.doubt() .. " Really? If so, use Done!", "ErrorMsg")
    return
  end

  core.done()
end, { bang = true })

create("DoToggle", core.toggle, {})
create("DoEdit", core.edit, {})
create("DoSave", core.save, { bang = true })

return core
