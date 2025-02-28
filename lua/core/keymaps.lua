vim.keymap.set({ "n", "i" }, "<C-s>", function() vim.cmd("w") end)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

vim.keymap.set("n", "gf", "<cmd>bnext<cr>")
vim.keymap.set("n", "gF", "<cmd>bprevious<cr>")

return false
