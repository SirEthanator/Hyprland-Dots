-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {
      underline = true,
      undercurl = false,
      sp = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg
    })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {
      underline = true,
      undercurl = false,
      sp = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg
    })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {
      underline = true,
      undercurl = false,
      sp = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }).fg
    })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {
      underline = true,
      undercurl = false,
      sp = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" }).fg
    })

    vim.api.nvim_set_hl(0, "SpellBad", {
      underline = true,
      undercurl = false,
      sp = vim.api.nvim_get_hl(0, { name = "SpellBad" }).fg
    })
    vim.api.nvim_set_hl(0, "SpellCap", {
      underline = true,
      undercurl = false,
      sp = vim.api.nvim_get_hl(0, { name = "SpellCap" }).fg
    })
    vim.api.nvim_set_hl(0, "SpellLocal", {
      underline = false,
      undercurl = false,
    })
    vim.api.nvim_set_hl(0, "SpellRare", {
      underline = true,
      undercurl = false,
      sp = vim.api.nvim_get_hl(0, { name = "SpellRare" }).fg
    })
  end,
})

