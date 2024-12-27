return
{
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup()
        local api = require("Comment.api")

        local modes = { "n", "x" }
        local toggle_comment_keys = { "<C-/>" }

        -- clear <C-c> keymap for not showing exit help
        vim.keymap.set(modes, "<C-c>", function() end)

        local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
        for _, key in ipairs(toggle_comment_keys) do
            vim.keymap.set("n", key, api.toggle.linewise.current)
            vim.keymap.set("x", key, function()
                vim.api.nvim_feedkeys(esc, "nx", false)
                api.toggle.linewise(vim.fn.visualmode())
            end)
        end
    end
}
