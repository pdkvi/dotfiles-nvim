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

        local try_kill_ft = function()
            local delete_buf = vim.api.nvim_get_current_buf()

            local current_ft = vim.api.nvim_get_option_value("filetype", {
                buf = delete_buf
            })

            for _, ft in ipairs(unkillable_fts) do
                if current_ft == ft then return false end
            end

            buffer.bufdelete(0, false)
            return vim.api.nvim_get_current_buf() ~= delete_buf
        end


        vim.keymap.set({ "n", "i" }, "<C-q>", try_kill_ft)
        vim.keymap.set({ "n", "i" }, "<C-S-q>", function()
            if try_kill_ft() == false then return end
            vim.api.nvim_win_close(0, false)
        end)

        require("scope").setup({})
        local _, telescope = pcall(require, "telescope")
        if telescope ~= nil then
            telescope.load_extension("scope")
        end
    end
}
