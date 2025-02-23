return
{
    "SmiteshP/nvim-navic",
    dependencies = { "SmiteshP/nvim-navbuddy", "MunifTanjim/nui.nvim" },
    config = function()
        -- TODO: separate kind_icons into separate module
        local kind_icons =
        {
            Text = '  ',
            Method = '  ',
            Function = '  ',
            Constructor = '  ',
            Field = '  ',
            Variable = '  ',
            Class = '  ',
            Interface = '  ',
            Module = '  ',
            Namespace     = "  ",
            Package       = "  ",
            Property = '  ',
            Unit = '  ',
            Value = '  ',
            Enum = '  ',
            Keyword = '  ',
            Snippet = '  ',
            Color = '  ',
            File = '  ',
            Reference = '  ',
            Folder = '  ',
            EnumMember = '  ',
            Constant = '  ',
            String        = "  ",
            Number        = "󰎠  ",
            Boolean       = "  ",
            Array         = "  ",
            Object        = "  ",
            Key           = "  ",
            Null          = "  ",
            Struct = '  ',
            Event = '  ',
            Operator = '  ',
            TypeParameter = '  '
        }

        local navic = require("nvim-navic")
        navic.setup({ icons = kind_icons })

        local navbuddy = require("nvim-navbuddy")
        local actions = require("nvim-navbuddy.actions")
        navbuddy.setup({
            icons = kind_icons,
            node_markers =
            {
                enabled = true,
                icons = { branch = " " }
            },
            window =
            {
                border = "rounded",
                scrolloff = 2
            },
            mappings =
            {
                ["<C-x>"] = actions.hsplit()
            }
        })

        vim.keymap.set("n", "<leader>n", navbuddy.open)
    end
}
