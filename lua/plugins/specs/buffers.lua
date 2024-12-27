-- TODO: separate at multiple modules with init.lua (?)

return
{
    "famiu/bufdelete.nvim",
    dependencies = { "tiagovla/scope.nvim" },

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

        require("scope").setup({})
        local _, telescope = pcall(require, "telescope")
        if telescope ~= nil then
            telescope.load_extension("scope")
        end
    end
}
