return
{
	"https://git.sr.ht/~swaits/scratch.nvim",
	keys =
	{
		{ "<C-\\>", "<cmd>Scratch<cr>", desc = "Scratch Buffer", mode = "n" },
	},

	cmd =
	{
		"Scratch",
		"ScratchSplit",
	},

	opts = {},
}
