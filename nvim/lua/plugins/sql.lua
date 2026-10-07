return {
  -- Tell Mason to install the sql-formatter
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "sql-formatter")
    end,
  },
}
