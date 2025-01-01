return {
  {
    "morhetz/gruvbox",
    config = function() vim.cmd.colorscheme("gruvbox") end
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    end
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "ruby", "markdown", "markdown_inline", "javascript", "html" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },  
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      lspconfig = require("lspconfig")
      lspconfig.ruby_lsp.setup({
        cmd = { "solargraph", "stdio" }, --https://solargraph.org/guides/language-server
        -- cmd = { "ruby-lsp" },
        on_attach = function(client, bufnr)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
          vim.keymap.set('n', "K", vim.lsp.buf.hover, { desc = "Show hover information" })
        end,
        settings = {
          solargraph = {
            diagnostics = true,  -- Enable diagnostics (optional)
            completion = true,   -- Enable code completion (optional)
            folding = true,      -- Enable code folding (optional)
            hover = true,        -- Enable hover functionality (optional)
            symbol_search = true -- Enable symbol search (optional)
          }
        }
        -- settings = {
        --   ruby = {
        --     diagnostics = {
        --       rubocop = {
        --         enable = true
        --       }
        --     }
        --   }
        -- }
      })
    end
  }
}
