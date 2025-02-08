-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Disable auto format
vim.g.autoformat = false

-- Enable pyright + qmlls
require'lspconfig'.pyright.setup{}
require'lspconfig'.qmlls.setup{}

-- Spell checking
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

