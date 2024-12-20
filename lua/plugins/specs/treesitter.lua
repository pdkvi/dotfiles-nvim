return
{
	"nvim-treesitter/nvim-treesitter",
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "lua", "cpp", "c", "cmake", "make", "comment" },
			sync_install = false,
			auto_install = false,
			highlight = { enable = true }
		})
	end,
	build = function() vim.cmd("TSUpdate") end
}
