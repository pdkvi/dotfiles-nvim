return
{
	"nvim-tree/nvim-tree.lua", opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		require("nvim-tree").setup({
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				api.config.mappings.default_on_attach(bufnr)

				local windows = vim.api.nvim_tabpage_list_wins(0)

				for _, window in ipairs(windows) do
					local buf = vim.api.nvim_win_get_buf(window)
					local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
					if bt == "" then return end
				end

				vim.cmd("enew")
				api.tree.open()
			end,

			hijack_cursor = true,
			sync_root_with_cwd = true,
			select_prompts = true,

			view =
			{
				preserve_window_proportions = true,
				width = 45
			},

			renderer =
			{
				special_files = {},
				highlight_modified = "name",

				indent_width = 2,
				indent_markers = { enable = true, },

				icons =
				{
					padding = "  ",
					symlink_arrow = "   ",

					glyphs =
					{
						modified = "[+]",
						folder =
						{
							arrow_closed = " ",
							arrow_open = " ",
						},
						git =
						{
							unstaged = "",
							staged = "󰄵",
							unmerged = "",
							renamed = "",
							untracked = "",
							deleted = "",
							ignored = "",
						}
					}
				}
			},

			modified = { enable = true },

			notify = { threshold = vim.log.levels.WARN }
		})

		local api = require("nvim-tree.api")
		vim.keymap.set("n", "<leader>e", api.tree.toggle, { desc = "Toggle filesystem tree" })
	end
}
