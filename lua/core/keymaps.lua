vim.keymap.set({ "n", "i" }, "<C-s>", function() vim.cmd("w") end)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

return false
