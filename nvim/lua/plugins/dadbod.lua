return {
  -- Database client for running SQL queries inside Neovim
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    config = function()
      -- Keybindings for dadbod-ui
      vim.keymap.set('n', '<leader>db', ':DBUI<CR>', { desc = "Open Database UI" })
      vim.keymap.set('n', '<leader>df', ':DBUIToggle<CR>', { desc = "Toggle Database UI" })
      vim.keymap.set('n', '<leader>dr', ':DBUI RenameBuffer<CR>', { desc = "Rename current buffer" })
      vim.keymap.set('n', '<leader>dl', ':DBUI LastQueryInfo<CR>', { desc = "Show last query info" })
      
      -- Set up completion for SQL in dadbod buffers
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_win_position = "right"
      vim.g.db_ui_win_row = 5
      vim.g.db_ui_win_width = 40
      
      -- Auto-completion setup
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {"sql", "mysql", "plsql"},
        callback = function()
          require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
        end
      })
    end
  }
}