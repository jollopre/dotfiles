-- General Settings
vim.o.background = "dark"
vim.o.backup = false              -- no backup made
vim.o.writebackup = false         -- no backup while writing
vim.o.swapfile = false            -- disables creating swap files

vim.wo.number = true              -- Show line numbers
vim.wo.linebreak = true           -- Break lines at word (requires wrap lines)
vim.o.showbreak = '+++'           -- Wrap-broken line prefix
vim.o.textwidth = 100             -- Line wrap (number of cols)
vim.o.showmatch = true            -- Highlight matching brace
vim.o.spell = true                -- Enable spell-checking
vim.o.visualbell = true           -- Use visual bell (no beeping)

vim.o.hlsearch = true             -- Highlight all search results
vim.o.ignorecase = true           -- Makes pattern matching case-insensitive
vim.o.smartcase = true            -- Overrides ignorecase if your pattern contains mixed case
vim.o.incsearch = true            -- Searches for strings incrementally

vim.o.autoindent = true           -- Auto-indent new lines
vim.o.expandtab = true            -- Use spaces instead of tabs
vim.o.shiftwidth = 2              -- Number of auto-indent spaces
vim.o.smartindent = true          -- Enable smart-indent
vim.o.smarttab = true             -- Enable smart-tabs
vim.o.softtabstop = 2             -- Number of spaces per Tab
vim.o.encoding = 'utf-8'          -- Set encoding to UTF-8
vim.o.foldmethod = 'indent'       -- Allows folding a block by its indentation level
vim.o.foldenable = false          -- Folding is disabled implicitly

-- Advanced Settings
vim.o.ruler = true                -- Show row and column ruler information
vim.o.undolevels = 1000           -- Number of undo levels
vim.o.backspace = 'indent,eol,start' -- Backspace behavior
vim.o.laststatus = 2              -- Used for status line (like lightline.vim)

vim.g.loaded_netrw = 1            -- Disable netrw
vim.g.loaded_netrwPlugin = 1      -- Disable netrw
