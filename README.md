# Fork

This fork fixes the documentation, removes unused configs and removes the "kaomijis" as they may not appeal to everyone who may use this plugin.

Task lists are saved in loaded in a per workspace basis.

Made mainly for personal use.

# Doing.nvim

A tinier task manager within nvim that helps you stay on track.

## Rationale

While coding, we often need to do several things that depend on another.
And it's quite easy to loose track of what we initially set out to do in the first place, which is also know as [Yak Shaving](https://en.wiktionary.org/wiki/yak_shaving).
_Or_ we just have a list of tasks that we want to work off step by step.

This plugin provides a few simple commands to help you stay on track.

It manages a list of things and always shows you the first item.
It provides you with some commands to add things to it, without leaving context.
And it uses a simple, intuitive floating buffer to manage that list.

## Usage

-  `:Do` add a line to the end of the list.
-  `:Do!` add a line to the front of list.
-  `:Done` remove the first line from the list.
-  `:DoEdit` edit the list in a floating window.
-  `:DoSave` create `.do_tasks` file in cwd. Will auto-sync afterwards.
-  `:DoToggle` toggle the display. Use with caution!

## Installation

 Requires Neovim 0.8.

lazy.nvim:

``` lua
{
  'hashino/do.nvim',
  config = function()
    require('do').setup {
      -- default options
      message_timeout = 2000, -- how long notifications are shown
      winbar = { enabled = true },

      doing_prefix = 'Current Task: ',
      store = {
        auto_create_file = true, -- automatically create a .tasks when calling :Do
        file_name = '.tasks',
      },
    }
    local api = require('doing.api')

    vim.keymap.set('n', '<leader>de', api.edit, { desc = '[E]dit what tasks you`re [D]oing' })
    vim.keymap.set('n', '<leader>dn', api.done, { desc = '[D]o[n]e with current task' })
  end,
}
```

## Lualine

In case you'd rather use it in the statusline or tabbar, you can use the exposed
views to do so. For example with lualine:

```lua
require('lualine').setup {
  winbar = {
    lualine_a = { require'doing.api'.status },
  },
}
```

## Events

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

