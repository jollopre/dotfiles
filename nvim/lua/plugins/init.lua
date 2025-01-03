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
        cmd = { "solargraph", "stdio" },
        on_attach = function(client, bufnr)
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          -- Hover
          vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
          -- Signature Help
          vim.keymap.set("n", "sh", vim.lsp.buf.signature_help, bufopts)
          -- References
          vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
          -- Formatting
          vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = false}) end, bufopts)
          -- Completion TODO
          -- Go to definition
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        end,
        settings = {
          solargraph = {
            hover = true,
            signature_help = true,
            references = true,
            formatting = true,
            completion = true,
            diagnostics = false,
            logLevel = "debug" -- TODO remove once solargraph is properly tuned
          }
        }
      })
    end
  }
}
