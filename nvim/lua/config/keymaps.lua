vim.keymap.set("n", "<leader>cp", "", {
  noremap = true,
  silent = true,
  callback = function()
    vim.fn.setreg('+', vim.fn.expand('%'))
  end
})
vim.keymap.set("n", "<leader>b", function()
  local filepath = vim.fn.expand("%:p")
  vim.cmd("!git blame " .. filepath)
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bn", "Next buffer", {
  noremap = true,
  silent = true,
  callback = function()
    vim.cmd("bnext")
  end
})
vim.keymap.set("n", "<leader>bp", "Previous buffer", {
  noremap = true,
  silent = true,
  callback = function()
    vim.cmd("bprev")
  end
})
vim.keymap.set("n", "<leader>bd", "Delete buffer", {
  noremap = true,
  silent = true,
  callback = function()
    vim.cmd("bdelete")
  end
})
