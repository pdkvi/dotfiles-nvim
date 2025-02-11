vim.keymap.set({ "n", "i" }, "<C-s>", function() vim.cmd("w") end)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

vim.keymap.set("n", "gn", "<cmd>bnext<cr>")
vim.keymap.set("n", "gp", "<cmd>bprevious<cr>")

return false
