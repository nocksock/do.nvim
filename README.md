> 🚧 Warning: this plugin is steaming fresh. Stuff might break.

# Do.nvim

```
       ....
   .xH888888Hx.
 .H8888888888888:           u.
 888*"""?""*88888X    ...ue888b
'f     d8x.   ^%88k   888R Y888r
'>    <88888X   '?8   888R I888>
 `:..:`888888>    8>  888R I888>
        `"*88     X   888R I888>
   .xHHhx.."      !  u8888cJ888
  X88888888hx. ..!    "*888*P"
 !   "*888888888"       'Y"
        ^"***"`
```

A tiny task manager within nvim that helps you stay on track.

## Rationale

While coding, we often need to do several things that depend on another.
And it's quite easy to loose track of what we initially set out to do in the first place, which is also know as [Yak Shaving](https://en.wiktionary.org/wiki/yak_shaving).
*Or* we just have a list of tasks that we want to work off step by step.

This plugin provides a few simple commands to help you stay on track.

It manages a list of things and always shows you the first item.
It provides you with some commands to add things to it, without leaving context.
And it uses a simple, intuitive floating buffer to manage that list.
-
## Usage

- `:Do` add a line to the end of the list.
- `:Do!` add a line to the front of list.
- `:Done!` remove the first line from the list.
- `:DoEdit` edit the list in a floating window.
- `:DoSave` create `.do_tasks` file in cwd. Will auto-sync afterwards.
- `:DoToggle` toggle the display. Use with caution!

## Installation

- Requires Neovim 0.8 (haven't tested with anything below)

```lua
-- use the package manager of your choice, eg. packer
use("https://github.com/nocksock/do.nvim")

-- setup wherever you do that in you config (eg init.lua)
require("do.nvim").setup({
  -- default options
  use_winbar = false, -- use the winbar (requires nvim 0.8)
  message_timeout = 2000, -- how long notifications are shown
  store = {
    auto_create_file = false, -- automatically create a .do_tasks when calling :Do
    file_name = ".do_tasks",
  }
}) 
```

## Lualine

To make this plugin actually show something, you'll have to mount its view
somewhere. I currentl like to have it in the winbar, using lualine. But it
should work anywhere really.

```lua
require('lualine').setup {
  winbar = {
    lualine_a = { require("do.nvim").view },
  },
  inactive_winbar = {},
}
```

## Development

### Run tests

🚧 There are none yet. Keeping this for future reference.

Running tests requires [plenary.nvim][plenary] to be checked out in the parent directory of *this* repository.
You can then run:

```bash
nvim --headless --noplugin -u tests/minimal.vim -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal.vim'}"
```

Or if you want to run a single test file:

```bash
nvim --headless --noplugin -u tests/minimal.vim -c "PlenaryBustedDirectory tests/path_to_file.lua {minimal_init = 'tests/minimal.vim'}"
```

[nvim-lua-guide]: https://github.com/nanotee/nvim-lua-guide
[plenary]: https://github.com/nvim-lua/plenary.nvim
[neobundle]: https://github.com/Shougo/neobundle.vim
[vundle]: https://github.com/gmarik/vundle
[vim-plug]: https://github.com/junegunn/vim-plug
[pathogen]: https://github.com/tpope/vim-pathogen
[dein]: https://github.com/Shougo/dein.vim
