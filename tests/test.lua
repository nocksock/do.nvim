vim.o.runtimepath = "../," .. vim.env.VIMRUNTIME
vim.wo.number = true
vim.o.relativenumber = true
vim.o.swapfile = false

require("do").setup({
  use_winbar = true
})
