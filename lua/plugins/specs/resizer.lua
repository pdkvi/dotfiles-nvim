return
{
    "pogyomo/winresize.nvim",
    dependencies = { "nvimtools/hydra.nvim" },

    config = function()
        local hydra = require("hydra")
        local resize = require("winresize").resize

        hydra({
            name = "Resize Mode",
            hint = "Resize Mode",
            mode = "n",
            body = "<C-S-r>",

            config =
            {
                exit = false,
                foreign_keys = 'warn',
                invoke_on_body = true,
                hint =
                {
                    type = "window",
                    position = "bottom",
                    -- Offset of the floating window from the nearest editor border
                    offset = 1,

                    -- options passed to `nvim_open_win()`, see :h nvim_open_win()
                    -- Lets you set border, header, footer, etc etc.
                    float_opts =
                    {
                        style = "minimal",
                        border = "rounded"
                    },

                    -- if set to true, this will prevent the hydra's hint window from displaying
                    -- immediately.
                    -- Note: you can still show the window manually by calling Hydra.hint:show()
                    -- and manually close it with Hydra.hint:close()
                    hide_on_load = false,

                    -- Table from function names to function. Functions should return
                    -- a string. These functions can be used in hints with %{func_name}
                    -- more in :h hydra-hint
                    funcs = {},
                }
            },

            -- these are explained below
            heads =
            {
                { "h", function() resize(0, 2,  "left") end, { desc = false } },
                { "j", function() resize(0, 1,  "down") end, { desc = false } },
                { "k", function() resize(0, 1,    "up") end, { desc = false } },
                { "l", function() resize(0, 2, "right") end, { desc = false } },

                {       'q', nil, { exit = true, desc = false } },
                {   '<ESC>', nil, { exit = true, desc = false } },
                { '<C-S-r>', nil, { exit = true, desc = false } },
            }
        })
    end
}
