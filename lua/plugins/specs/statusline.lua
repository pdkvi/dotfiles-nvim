local color = require("lackluster.color")
local color_special = require("lackluster.color-special")

local theme =
{
    normal =
	{
        a = { bg = color.gray4, fg = color.gray7, gui = "bold" },
        b = { bg = color_special.statusline, fg = color.gray7 },
        c = { bg = color_special.statusline, fg = color.gray7 },
    },

    insert =
	{
        a = { bg = color.green, fg = color.black, gui = "bold" },
        b = { bg = color_special.statusline, fg = color.gray7 },
        c = { bg = color_special.statusline, fg = color.gray7 },
    },

    command =
	{
        a = { bg = color.green, fg = color.black, gui = "bold" },
        b = { bg = color_special.statusline, fg = color.gray7 },
        c = { bg = color_special.statusline, fg = color.gray7 },
    },

    visual =
	{
        a = { bg = color.gray9, fg = color.black, gui = "bold" },
        b = { bg = color_special.statusline, fg = color.gray7 },
        c = { bg = color_special.statusline, fg = color.gray7 },
    },

    replace =
	{
        a = { bg = color.gray9, fg = color.black, gui = "bold" },
        b = { bg = color_special.statusline, fg = color.gray7 },
        c = { bg = color_special.statusline, fg = color.gray7 },
    },

    inactive =
	{
        a = { bg = color.gray1, fg = color.gray4, gui = "bold" },
        b = { bg = color.gray1, fg = color.gray4 },
        c = { bg = color.gray1, fg = color.gray4 },
    },
}

return
{
	"nvim-lualine/lualine.nvim",
	dependencies =
	{
		"nvim-tree/nvim-web-devicons",
		--"linrongbin16/lsp-progress.nvim"
	},

	config = function()
		local lualine = require("lualine")
		lualine.setup({
			options =
			{
				theme = theme,
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
