return
{
	"nvim-lualine/lualine.nvim",
	dependencies =
	{
		"nvim-tree/nvim-web-devicons",
		--0"linrongbin16/lsp-progress.nvim"
	},

	config = function()
		local lualine = require("lualine")
		local i
		lualine.setup({
			options =
			{
				component_separators = { left = "", right = "" },
				section_separators = { left = '', right = ''},
				disabled_filetypes =
				{
					statusline = { "NvimTree", "neo-tree", "trouble" },
				}
			},
			sections =
			{
				lualine_a =
				{
					{ "mode", fmt = string.lower }
				},

				lualine_b =
				{
					"branch", "diff",
					{
						"diagnostics",
						diagnostics_color =
						{
							error = { name = "DiagnosticError", gui = "bold" },
							warn  = { name = "DiagnosticWarn", gui = "bold" },
							info  = { name = "DiagnosticInfo", gui = "bold" },
							hint  = { name = "DiagnosticHint", gui = "bold" }
						},
						symbols = { error = " ", warn= " ", info = " ", hint = " " }
					}
				},

				lualine_c =
				{
					{
						'filename',
						separator = "",
						newfile_status = true,
						symbols = { readonly = "[r/o]" }
					}
				},
				lualine_x =
				{
					--[[ {
						"overseer",
						label = "", -- Prefix for task counts
						colored = true, -- Color the task icons and counts
						symbols = {
							[overseer.STATUS.FAILURE] = "F:",
							[overseer.STATUS.CANCELED] = "C:",
							[overseer.STATUS.SUCCESS] = "S:",
							[overseer.STATUS.RUNNING] = "R:",
						},
						unique = false, -- Unique-ify non-running task count by name
						name = nil, -- List of task names to search for
						name_not = false, -- When true, invert the name search
						status = nil, -- List of task statuses to display
						status_not = false, -- When true, invert the status search
					}, ]]
				},
				lualine_y =
				{
					{ 'encoding', separator = "/" },

					{
						'fileformat', separator = "/",
						icons_enabled = true,
						symbols = { unix = "lf", dos = "crlf", mac = "cr" }
					}
				},
				lualine_z =
				{
					{ 'progress', separator = "/" }, { 'location' }
				}
			}
		})
	end
}
