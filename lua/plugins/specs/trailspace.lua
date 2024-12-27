return
{
    "echasnovski/mini.trailspace",
    config = function()
        local trailspace = require("mini.trailspace")
        trailspace.setup()
        vim.api.nvim_set_hl(0, "MiniTrailspace", {
            bg = vim.api.nvim_get_hl(0, { name = "DiagnosticError", link = false }).fg
        })

        vim.api.nvim_create_autocmd("BufWrite", {
            pattern = "*",
            callback = function()
                trailspace.trim()
                trailspace.trim_last_lines()
            end
        })
    end
}
