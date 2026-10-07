return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        nix = { "nixfmt" },
        sql = { "sql_formatter" },
      },
      formatters = {
        sql_formatter = {
          args = { "--config", '{"keywordCase": "upper"}' },
        },
      },
    },
  },
}
