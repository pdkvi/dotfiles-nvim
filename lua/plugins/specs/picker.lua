return
{
	"yorickpeterse/nvim-window",

	config = function()
		local picker = require("nvim-window")
		vim.keymap.set("n", "<C-w><C-w>", function() picker.pick() end)
	end
}
