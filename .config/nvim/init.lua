-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Disable auto format
vim.g.autoformat = false

-- Enable pyright + qmlls
vim.lsp.enable('pyright')
vim.lsp.enable('qmlls')

-- Spell checking
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

