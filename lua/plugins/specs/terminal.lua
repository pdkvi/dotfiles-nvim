-- TODO: create pull request with my changes to this ('rebelot/terminal.nvim') plugin

return
{
	"rebelot/terminal.nvim",
	config = function()
		vim.api.nvim_set_hl(0, "FloatBorder", { link = "WinSeparator" })

		local termapi = require("terminal")
		termapi.setup({})

		local tabonly_terminals = {}

		vim.keymap.set({ "n", "t" }, "<C-`>", function()
			local current_tab = vim.api.nvim_get_current_tabpage()

			if tabonly_terminals[current_tab] == nil then
				tabonly_terminals[current_tab] = termapi.terminal:new({
					cmd = { vim.o.shell, "-i" },
					layout =
					{
						open_cmd = "float",
						border = { "│", " " ,"│", "│", "┘", "─", "└", "│" },
						height = 0.55, width = function() return vim.o.columns - 4 end,
						row = 1
					},
					autoclose = true
				})
			end

			tabonly_terminals[current_tab]:toggle()
		end)

		vim.api.nvim_create_autocmd("TermOpen",
		{
			callback = function()
				vim.wo.number = false
				vim.wo.relativenumber = false
				vim.wo.winhl = "Normal:Normal"
			end
		})

		vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" },
		{
			callback = function(args)
				if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
					vim.cmd("startinsert")
				end
			end,
		})
	end
}
