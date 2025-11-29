-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Enable LSPs
vim.lsp.enable("pyright")
vim.lsp.enable("qmlls")
