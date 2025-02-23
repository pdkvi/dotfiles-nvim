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
    dependencies =
    {
        "nvim-tree/nvim-web-devicons",
        "linrongbin16/lsp-progress.nvim"
    },

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

        local progress = require("lsp-progress")
        progress.setup({
            client_format = function(client_name, spinner, series_messages)
                if #series_messages == 0 then return nil end

                return
                {
                    name = client_name,
                    body = spinner .. " " .. table.concat(series_messages, ", ")
                }
            end,

            format = function(client_messages)
                --- @param name string
                --- @param msg string?
                --- @return string
                local function stringify(name, msg)
                    return msg and string.format("%s %s", name, msg) or name
                end

                local sign = "LSP ::"

                local messages_map = {}
                for _, climsg in ipairs(client_messages) do
                    messages_map[climsg.name] = climsg.body
                end

                local clients = vim.iter(vim.lsp.get_clients())
                clients = clients:filter(function(client)
                    return type(client) == "table"
                        and type(client.name) == "string"
                        and string.len(client.name) > 0
                end)

                local builder = {}
                clients:each(function(client)
                    if messages_map[client.name] then
                        table.insert(builder, stringify(client.name, messages_map[client.name]))
                    else
                        table.insert(builder, stringify(client.name))
                    end
                end)

                if #builder > 0 then
                    return sign .. " " .. table.concat(builder, ", ")
                end

                return ""
            end
        })

        local progress_to_element = function(line)
            local content = progress.progress()
            if content == "" then return "" end

            return content == "" and "" or
            {
                line.sep(' █', theme.head, theme.fill),
                { content, hl = theme.head },
                line.sep('█', theme.head, theme.fill),
            }
        end

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

                    progress_to_element(line),

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

        vim.api.nvim_create_augroup("tabby_augroup", { clear = true })
        vim.api.nvim_create_autocmd("User",
        {
            group = "tabby_augroup",
            pattern = "LspProgressStatusUpdated",
            callback = function() tabby.update() end
        })
    end
}
