-- TODO: change list of windows with LSP status or smth like that

local theme =
{
	fill = 'TabLineFill',
	-- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
	head = 'TabLine',
	current_tab = 'TabLineSel',
	tab = 'TabLine',
	win = 'TabLine',
	tail = 'TabLine',
}

---@param win TabbyWin
---@return boolean
local function wins_filter(win)
	-- local excluded_fts = { "edgy", "NvimTree", "trouble", "cmake_tools_terminal" }
	-- local ft = vim.api.nvim_get_option_value("ft", { buf = win.buf().id })
	local buft = vim.api.nvim_get_option_value("bt", { buf = win.buf().id })
	local excluded_bufts = { "nofile", "prompt" }

	return not vim.list_contains(excluded_bufts, buft)
		-- and not vim.list_contains(excluded_fts, ft)
end

local function tab_rename()
	local input_opts = { prompt = "New tab name:", kind = "globally_centered" }
	vim.ui.input(input_opts, function(input)
		local set_tab_name = require("tabby.feature.tab_name").set
		set_tab_name(0, input)
	end)
end

return
{
	"nanozuki/tabby.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		vim.o.showtabline = 2

		vim.keymap.set("n", "<leader>tn", function()
			vim.cmd("tabnew")
			vim.cmd("StarterOpen")
		end)

		vim.keymap.set("n", "<leader>tc", function()
			local windows = vim.api.nvim_tabpage_list_wins(0)
			for _, window in ipairs(windows) do
				local buffer = vim.api.nvim_win_get_buf(window)
				vim.api.nvim_buf_delete(buffer, { force = false, unload = false })
			end
		end)

		vim.keymap.set("n", "<leader>tr", tab_rename)

		require("tabby").setup({
			line = function(line)
				return
				{
					{
						{ '   ', hl = theme.head },
						line.sep(' ', theme.head, theme.fill),
					},

					line.wins_in_tab(line.api.get_current_tab()).filter(wins_filter).foreach(function(win)
						return
						{
							line.sep('', theme.win, theme.fill),
							win.is_current() and '' or '',
							win.buf_name(),
							line.sep('', theme.win, theme.fill),
							hl = theme.win,
							margin = ' ',
						}
					end),


					line.spacer(),

					line.tabs().foreach(function(tab)
						local hl = tab.is_current() and theme.current_tab or theme.tab
						return
						{
							line.sep('', hl, theme.fill),
							tab.is_current() and '' or '',
							tab.number(),
							tab.name(),
							" ",
							line.sep('', hl, theme.fill),
							hl = hl,
							margin = ' ',
						}
					end),

					{
						line.sep(' ', theme.tail, theme.fill),
						{ '  󰓩  ', hl = theme.tail },
					},

					hl = theme.fill,
				}
			end,
		})
	end
}
