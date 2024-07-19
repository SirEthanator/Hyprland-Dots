-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Disable auto format
vim.g.autoformat = false

-- Enable pyright
require'lspconfig'.pyright.setup{}

