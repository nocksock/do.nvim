# Doing.nvim

A tiny task manager within nvim that helps you stay on track.

this plugin is a fork of [do.nvim](https://github.com/nocksock/do.nvim)

![doing](https://raw.githubusercontent.com/Hashino/doing.nvim/main/demo/demo.gif)

## Rationale

While coding, we often need to do several things that depend on another.
And it's quite easy to loose track of what we initially set out to do in the first place, which is also know as [Yak Shaving](https://en.wiktionary.org/wiki/yak_shaving).
_Or_ we just have a list of tasks that we want to work off step by step.

This plugin provides a few simple commands to help you stay on track.

It manages a list of things and always shows you the first item.
It provides you with some commands to add things to it, without leaving context.
And it uses a simple, intuitive floating buffer to manage that list.

## Usage

-  `:Do` add a task to the end of the list.
-  `:Do!` add a task to the front of list.
-  `:Done` remove the first task from the list.
-  `:DoEdit` edit the tasklist in a floating window.
-  `:DoSave` create `.tasks` file in cwd. Will auto-sync afterwards.
-  `:DoToggle` toggle the display. Use with caution!

## Installation

 Requires Neovim 0.8.

lazy.nvim:

```lua
-- minimal installations
return {
  'Hashino/doing.nvim',
  config = true,
}
```

## Configuration

``` lua
-- example configuration
return {
  'hashino/do.nvim',
  config = function()
    require('do').setup {
      -- default options
      message_timeout = 2000,
      winbar = { 
        enabled = true,
        -- ignores buffers that match filetype
        ignored_buffers = { 'NvimTree' }
      },

      doing_prefix = 'Current Task: ',
      store = {
        -- automatically create a .tasks when calling :Do
        auto_create_file = true, 
        file_name = '.tasks',
      },
    }
    -- example on how to change the winbar highlight
    vim.api.nvim_set_hl(0, 'WinBar', { link = 'Search' })

    local api = require('doing.api')

    vim.keymap.set('n', '<leader>de', api.edit, { desc = '[E]dit what tasks you`re [D]oing' })
    vim.keymap.set('n', '<leader>dn', api.done, { desc = '[D]o[n]e with current task' })
  end,
}
```

### Lualine

In case you'd rather use it in the statusline or tabbar, you can use the exposed
views to do so. For example with lualine:

```lua
require('lualine').setup {
  winbar = {
    lualine_a = { require'doing.api'.status },
  },
}
```

### Events

This plugin exposes a custom event, for when a task is added or modified. You can use it like so:

```lua
vim.api.nvim_create_autocmd({ "User" }, {
   group = require("do.state").state.auGroupID,
   pattern = "TaskModified",
   desc = "This is called when a task is added or deleted",
   callback = function()
      vim.notify("A task has been modified")
   end,
})
```

