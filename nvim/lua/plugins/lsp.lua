return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- Integration with autocomplete
    },
      config = function()
        -- 1. Setup Mason
        require("mason").setup()
        
       -- 2. Capabilities for Autocompletion
       local capabilities = require('cmp_nvim_lsp').default_capabilities()
       local lspconfig = require("lspconfig")
 
        -- 3. Setup Mason LSP Config with handlers
        require("mason-lspconfig").setup({
          ensure_installed = { "lua_ls", "pyright", "ts_ls", "sqlls" },
          automatic_installation = true,
         handlers = {
           function(server_name)
             lspconfig[server_name].setup({
               capabilities = capabilities,
             })
           end,
           
           -- Dedicated config for specific servers (optional)
           lua_ls = function()
             lspconfig.lua_ls.setup({
               capabilities = capabilities,
               settings = { Lua = { diagnostics = { globals = { "vim" } } } }
             })
           end,
         }
       })

      -- 4. Keybindings (Global)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
    end
  }
}
