return
{
    "luukvbaal/statuscol.nvim",

    opts = function()
        local builtin = require("statuscol.builtin")

        return
        {
            bt_ignore = { "nofile", "terminal" },
            segments =
            {
                -- padding
                { text = { " " } },

                -- other signs
                {
                    sign =
                    {
                        name = { ".*" },
                        text = { ".*" },
                        maxwidth = 1, colwidth = 2,
                        auto = true, wrap = false
                    },
                    click = "v:lua.ScSa"
                },

                -- diagnostic
                {
                    sign =
                    {
                        namespace = { "diagnostic/sign" },
                        maxwidth = 1, colwidth = 2,
                        auto = true, wrap = false,
                        foldclosed = true
                    },
                    click = "v:lua.ScSa"
                },

                -- line numbers
                {
                    text =
                    {
                        function(args)
                            return builtin.lnumfunc(args) .. " "
                        end
                    },
                    click = "v:lua.ScLa"
                },

                -- gitsigns
                {
                    sign =
                    {
                        namespace = { "gitsigns" },
                        maxwidth = 1, colwidth = 2,
                        auto = true, wrap = true
                    },
                    click = "v:lua.ScSa"
                },

                -- folds
                {
                    text =
                    {
                        function(args)
                            args.fold.close = ""
                            args.fold.open = ""
                            args.fold.sep = "▕"

                            return builtin.foldfunc(args) .. " "
                        end
                    },
                    click = "v:lua.ScFa"
                }
            }
        }
    end,
}
