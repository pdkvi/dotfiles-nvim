-- TODO: change list of windows with LSP status or smth like that

local theme =
{
    fill = 'TabLineFill',
    -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
    head = 'TabLine',
    current_tab = 'TabLineSel',
    tab = 'TabLine',
    tail = 'TabLine',
}

local function tab_rename()
    local input_opts = { prompt = "New tab name:", kind = "globally_centered" }
    vim.ui.input(input_opts, function(input)
        local set_tab_name = require("tabby.feature.tab_name").set
        set_tab_name(0, input)
    end)
end

return
{
    "nanozuki/tabby.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        vim.o.showtabline = 2

        vim.keymap.set("n", "<leader>tn", function()
            vim.cmd("tabnew")
            vim.cmd("StarterOpen")
        end)

        vim.keymap.set("n", "<leader>tc", function()
            ---@diagnostic disable-next-line: param-type-mismatch
            local is_closed = pcall(vim.cmd, "tabclose")

            if is_closed == false then
                vim.notify("Cannot close last tab page", vim.log.levels.ERROR, {
                    title = "Error"
                })
            end
        end)

        vim.keymap.set("n", "<leader>tr", tab_rename)

        local tabby = require("tabby")
        tabby.setup({
            line = function(line)
                return
                {
                    {
                        { '   ', hl = theme.head },

                        line.sep(' ', theme.head, theme.fill),
                    },

                    { "TIME: " .. os.date("%H:%M") },


                    line.spacer(),

                    line.tabs().foreach(function(tab)
                        local hl = tab.is_current() and theme.current_tab or theme.tab
                        return
                        {
                            line.sep('', hl, theme.fill),
                            tab.is_current() and '' or '',
                            tab.number(),
                            tab.name(),
                            " ",
                            line.sep('', hl, theme.fill),
                            hl = hl,
                            margin = ' ',
                        }
                    end),

                    {
                        line.sep(' ', theme.tail, theme.fill),
                        { '  󰓩  ', hl = theme.tail },
                    },

                    hl = theme.fill,
                }
            end,
        })
    end
}
