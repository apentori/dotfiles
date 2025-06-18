return {
        'nvim-neo-tree/neo-tree.nvim',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
           -- "3rd/image.nvim",
        },
        lazy = false, -- neo-tree will lazily load itself
          ---@module "neo-tree"
          ---@type neotree.Config?
        opts = {
          rocks = {
            enabled = false,
            hererocks = false,
          }
        },
        config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            visible = true,
            show_hidden_count = true,
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
        },
        buffers = { follow_current_file = { enable = true } },
      })
    end,
}
