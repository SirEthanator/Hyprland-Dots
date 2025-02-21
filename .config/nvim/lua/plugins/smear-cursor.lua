return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  cond = vim.g.neovide == nil,

  config = function()
    require('smear_cursor').enabled = true
  end,

  opts = {
    hide_target_hack = true;
    cursor_color = "none",
    legacy_computing_symbols_support = true,
    stiffness = 0.8,
    trailing_stiffness = 0.4,
    stiffness_insert_mode = 0.8,
    trailing_stiffness_insert_mode = 0.4,
    trailing_exponent_insert_mode = 2,
    distance_stop_animating_vertical_bar = 0.1
  }
}
