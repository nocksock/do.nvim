vim.o.runtimepath = "../," .. vim.env.VIMRUNTIME
vim.wo.number = true
vim.o.relativenumber = true
vim.o.swapfile = false

vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('n', '<c-h>', '<c-w>h')

require("do").setup({
  winbar = true
})

