return {
  {
  "luxvim/nvim-luxterm",
  config = function()
    require("luxterm").setup({
      -- Optional configuration
      manager_width = 0.8,
      manager_height = 0.8,
      preview_enabled = true,
      auto_hide = true,
      keymaps = {
          toggle_manager = "<C-/>",     -- Toggle session manager
          next_session = "<C-k>",       -- Next session keybinding
          prev_session = "<C-j>",       -- Previous session keybinding
          global_session_nav = false,   -- Enable global session navigation
      }
    })
  end
},
}
