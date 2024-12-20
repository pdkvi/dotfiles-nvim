return
{
	"slugbyte/lackluster.nvim",
	proprity = 1000,
	init = function()
		require("lackluster").setup({
			disable_plugin = {},
			tweak_syntax = {},
			tweak_background = { popup = "none" },
		})

		vim.cmd.colorscheme("lackluster-dark")

		local color = require("lackluster").color

		vim.api.nvim_set_hl(0, "WinBar", { fg = color.gray7, bg = color.gray3, bold = true })
		vim.api.nvim_set_hl(0, "WinBarNC", { fg = color.gray7, bg = color.gray3, bold = false })
		vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = color.orange })
	end
}
