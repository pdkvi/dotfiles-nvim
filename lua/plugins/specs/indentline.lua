return
{
    "lukas-reineke/indent-blankline.nvim",

    main = "ibl",
    opts =
    {
        indent = { char = "╎" },

        scope =
        {
            show_start = false,
            show_end = false,

            include = {
                node_type = { lua = { "return_statement", "table_constructor" } }
            },
        },

        exclude = {
            buftypes = { "terminal" }
        }
    }
}
