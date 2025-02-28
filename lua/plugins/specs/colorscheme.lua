local kind_icons =
{
    Text = ' ',
    Method = ' ',
    Function = ' ',
    Constructor = ' ',
    Field = ' ',
    Variable = ' ',
    Class = ' ',
    Interface = ' ',
    Module = ' ',
    Property = ' ',
    Unit = ' ',
    Value = ' ',
    Enum = ' ',
    Keyword = ' ',
    Snippet = ' ',
    Color = ' ',
    File = ' ',
    Reference = ' ',
    Folder = ' ',
    EnumMember = ' ',
    Constant = ' ',
    Struct = ' ',
    Event = ' ',
    Operator = ' ',
    TypeParameter = ' ',
}

local function common_integrations()
    ---@param name string
    ---@return vim.api.keyset.highlight
    local function hl(name)
        ---@diagnostic disable-next-line: return-type-mismatch
        return vim.api.nvim_get_hl(0, { name = name, link = false })
    end

    vim.api.nvim_set_hl(0, "DapUIScope", { link = "WinBar" })
    vim.api.nvim_set_hl(0, "DapUIThread", { link = "WinBar" })
    vim.api.nvim_set_hl(0, "DapUIStoppedThread", { link = "WinBar" })
    vim.api.nvim_set_hl(0, "DapUIBreakpointsPath", { link = "WinBar" })
    vim.api.nvim_set_hl(0, "DapUIDecoration", { link = "FoldColumn" })
    vim.api.nvim_set_hl(0, "DapUIWatchesValue", { link = "FoldColumn" })
    vim.api.nvim_set_hl(0, "DapUIType", { link = "Type" })
    vim.api.nvim_set_hl(0, "DapUISource", { link = "Conceal" })
    vim.api.nvim_set_hl(0, "DapUILineNumber", { link = "Conceal" })
    vim.api.nvim_set_hl(0, "DapUIBreakpointsInfo", { link = "QuickFixLine" })
    vim.api.nvim_set_hl(0, "DapUIBreakpointsCurrentLine", { link = "QuickFixLine" })
    vim.api.nvim_set_hl(0, "DapUIWatchesEmpty", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "DapUIWatchesError", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "DapUIModifiedValue", { link = "WarningMsg" })
    vim.api.nvim_set_hl(0, "DapUIFloatBorder", { link = "FloatBorder" })

    vim.api.nvim_set_hl(0, "TelescopeMatching", { bold = true })

    vim.api.nvim_set_hl(0, "MiniTrailspace", { bg = hl("DiagnosticError").fg })

    vim.api.nvim_set_hl(0, "GlancePreviewMatch", { link = "GlancePreviewNormal" })

    vim.api.nvim_set_hl(0, "TroubleIndent", { fg = hl("LineNr").fg })
    vim.api.nvim_set_hl(0, "TroublePos", { fg = hl("LineNr").fg })
    vim.api.nvim_set_hl(0, "TroubleNormal", { link = "TroubleNormal" })
    vim.api.nvim_set_hl(0, "TroubleNormalNC", { link = "TroubleNormalNC" })

    local higroup_names = { "CmpItemKind" }
    for kind in pairs(kind_icons) do
        if type(kind) == "string" then
            higroup_names[#higroup_names + 1] = ("CmpItemKind%s"):format(kind)
        end
    end

    for _, name in ipairs(higroup_names) do
        local group = vim.api.nvim_get_hl(0, { name = name, link = false })
        vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", group, { reverse = true }))
    end

    vim.api.nvim_set_hl(0, "CmpItemMenu",
    vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = "CmpItemMenu" }), { bold = true })
    )
end
return
{
    "slugbyte/lackluster.nvim",
    dependencies = { "yorickpeterse/nvim-grey" },
    priority = 1000,
    init = function()
        vim.api.nvim_create_user_command("Light", function()
            vim.cmd("hi clear")
            vim.cmd.colorscheme("grey")
            common_integrations()
        end, {})

        vim.api.nvim_create_user_command("Dark", function()
            vim.cmd("hi clear")

            local color = require("lackluster").color
            local color_special = require("lackluster.color-special")
            local theme = require("lackluster.create-theme")(color, color_special)
            vim.cmd.colorscheme("lackluster")

            common_integrations()

            vim.api.nvim_set_hl(0, "DapStoppedText", { fg = color.yellow, bold = true })

            -- cursorline
            -- vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
            vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = color.gray2 })

            vim.api.nvim_set_hl(0, "@type.definition", { link = "@type", force = true })

            vim.api.nvim_set_hl(0, "WinBar", { fg = color.gray6, bg = color.gray2, bold = false })
            vim.api.nvim_set_hl(0, "WinBarNC", { fg = color.gray6, bg = color.gray2, bold = false })

            vim.api.nvim_set_hl(0, "TabLine", { fg = color.gray5, bg = color.gray2, bold = false })
            vim.api.nvim_set_hl(0, "TabLineFill", { fg = color.gray7, bg = theme.ui.bg_statusline, bold = true })

            vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = color.orange })

            vim.api.nvim_set_hl(0, "ColorColumn", { fg = theme.ui.fg_statusline, bg = theme.ui.bg_statusline })

            vim.api.nvim_set_hl(0, "Added", { fg = color.green })
            vim.api.nvim_set_hl(0, "DiffAdded", { fg = color.green })

            vim.api.nvim_set_hl(0, "Changed", { fg = color.orange })
            vim.api.nvim_set_hl(0, "DiffChanged", { fg = color.orange })

            vim.api.nvim_set_hl(0, "Removed", { fg = color.red })
            vim.api.nvim_set_hl(0, "DiffRemoved", { fg = color.red })
        end, {})

        local color = require("lackluster").color
        local color_special = require("lackluster.color-special")
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

        vim.cmd("Dark")
    end
}
