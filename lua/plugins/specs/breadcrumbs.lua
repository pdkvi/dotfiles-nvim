return
{
    "SmiteshP/nvim-navic",
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
    end
}
