return
{
    "slugbyte/lackluster.nvim",
    proprity = 1000,
    init = function()
        local color = require("lackluster").color
        local accent_color = "#5a725a"
        require("lackluster").setup({
            disable_plugin =
            {
                git_signs = true,
                git_gutter = true
            },
            tweak_syntax =
            {
                string = accent_color,
                type = color.green,
                type_primitive = color.green,
                func_param = color.gray7,
            },
            tweak_background = { popup = "none" },
        })

        local color_special = require("lackluster.color-special")
        local theme = require("lackluster.create-theme")(color, color_special)

        vim.cmd.colorscheme("lackluster")

        vim.api.nvim_set_hl(0, "@type.definition", { link = "@type", force = true })

        vim.api.nvim_set_hl(0, "WinBar", { fg = color.gray7, bg = color.gray3, bold = true })
        vim.api.nvim_set_hl(0, "WinBarNC", { fg = color.gray7, bg = color.gray3, bold = false })
        vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = color.orange })

        vim.api.nvim_set_hl(0, "ColorColumn", { fg = theme.ui.fg_statusline, bg = theme.ui.bg_statusline })

        vim.api.nvim_set_hl(0, "Added", { fg = color.green })
        vim.api.nvim_set_hl(0, "DiffAdded", { fg = color.green })

        vim.api.nvim_set_hl(0, "Changed", { fg = color.orange })
        vim.api.nvim_set_hl(0, "DiffChanged", { fg = color.orange })

        vim.api.nvim_set_hl(0, "Removed", { fg = color.red })
        vim.api.nvim_set_hl(0, "DiffRemoved", { fg = color.red })
    end
}
