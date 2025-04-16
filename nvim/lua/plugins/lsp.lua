return{
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
          logLevel = "error" -- Logs are dumped into ~/.local/state/nvim/lsp.log
        }
      }
    })
  end
}
