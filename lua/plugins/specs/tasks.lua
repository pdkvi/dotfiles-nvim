return
{
	"stevearc/overseer.nvim",
	config = function()
		local overseer = require("overseer")
		overseer.setup({})
		overseer.load_template("cmake")
	end
}
