vim.keymap.set("n", "<leader>cp", "", {
  noremap = true,
  silent = true,
  callback = function()
    vim.fn.setreg('+', vim.fn.expand('%'))
  end
})
vim.keymap.set('n', '<leader>b', function()
  local filepath = vim.fn.expand('%:p')
  vim.cmd('!git blame ' .. filepath)
end, { noremap = true, silent = true })
