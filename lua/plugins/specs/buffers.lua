return
{
	"famiu/bufdelete.nvim",

	config = function()
		local buffer = require("bufdelete")

		---@type string[]
		local unkillable_fts =
		{
			"NvimTree", "lazy"
		}

		vim.keymap.set({ "n", "i" }, "<C-q>", function()
			local current_ft = vim.api.nvim_get_option_value("filetype", {
				buf = vim.api.nvim_get_current_buf()
			})

			for _, ft in ipairs(unkillable_fts) do
				if current_ft == ft then return end
			end

			buffer.bufdelete(0, false)
		end)
	end
}
