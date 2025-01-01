return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function () 
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "ruby", "javascript", "html" },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },  
    })
  end,
  ft = { "c", "lua", "vim", "vimdoc", "query",  "markdown", "markdown_inline" },
}
