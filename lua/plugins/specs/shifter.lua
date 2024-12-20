return
{
	--"sindrets/winshift.nvim",
	"jam1015/winshift.nvim",
	config = function()
		-- TODO: commit for floating window support
		vim.keymap.set("n", "<C-S-s>", "<cmd>WinShift<cr>")
		vim.keymap.set("n", "<C-S-w>", "<cmd>WinShift swap<cr>")
	end
}
