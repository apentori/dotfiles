return {
  "nvim-neorocks/new-file-template.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("new-file-template").setup({
      templates_dir = vim.fn.stdpath("config") .. "/lua/templates",
    })
  end,
}
