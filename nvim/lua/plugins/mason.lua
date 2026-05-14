return {
  { "mason-org/mason.nvim",
    dependencies = { "mason-org/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      ensure_installed = {
        -- LSP servers
        "ruff",
        "typescript-language-server",
        "eslint-lsp",
        "nil",
        "html-lsp",
        "css-lsp",
        "sql-language-server",
        -- Linters
        "eslint_d",
        "statix",
        "htmlhint",
        "stylelint",
        "sqlfluff",
        -- Formatters
        "prettier",
        "nixfmt",
      },
    },
  },
}
