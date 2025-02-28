return
{
    "echasnovski/mini.trailspace",
    config = function()
        local trailspace = require("mini.trailspace")
        trailspace.setup()

        vim.api.nvim_create_autocmd("BufWrite", {
            pattern = "*",
            callback = function()
                trailspace.trim()
                trailspace.trim_last_lines()
            end
        })
    end
}
