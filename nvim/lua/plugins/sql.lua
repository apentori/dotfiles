return {
  -- 1. Tell Mason to install the formatter
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "sql-formatter")
    end,
  },

  -- 2. Tell Conform to use it for SQL files
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "sql_formatter" },
      },
      -- Optional: Customize the arguments (e.g., uppercase keywords)
      formatters = {
        sql_formatter = {
          args = { "--config", '{"keywordCase": "upper"}' },
        },
      },
    },
  },
}
