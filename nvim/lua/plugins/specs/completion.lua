-- TODO: create dynamic construction of kinds filter (?)

return
{
    "hrsh7th/nvim-cmp",

    dependencies =
    {
        -- snippets
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        -- git
        "davidsierradz/cmp-conventionalcommits",

        -- path
        "FelipeLema/cmp-async-path",

        -- lsp
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lsp",

        -- calc
        "hrsh7th/cmp-calc",

        -- buffer
        "hrsh7th/cmp-buffer",

        -- cmdline
        "hrsh7th/cmp-cmdline"
    },

    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        ---call fallback on function failure
        ---@param fallback function fallback function
        ---@param result boolean result of the call
        ---@return boolean _ is fallback called
        local function fcall(fallback, result)
            -- if result == false then
            if not result then
                fallback()
                return true
            end

            return false
        end

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

        local cmp_mappings = {}

        cmp_mappings["<C-j>"] = function(fallback) fcall(fallback, cmp.scroll_docs(3)) end
        cmp_mappings["<C-k>"] = function(fallback) fcall(fallback, cmp.scroll_docs(-3)) end

        cmp_mappings["<C-l>"] = function(fallback)
            if cmp.visible_docs() then
                fcall(fallback, cmp.close_docs())
            else
                fcall(fallback, cmp.open_docs())
            end
        end

        cmp_mappings["<Tab>"] = function(fallback)
            if cmp.visible() == false then
                if fcall(fallback, luasnip.locally_jumpable(1)) == false then
                    luasnip.jump(1)
                end

                return
            end

            if luasnip.expandable() then
                luasnip.expand()
            else
                fcall(fallback, cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }))
            end
        end

        cmp_mappings["<S-Tab>"] = function(fallback)
            if cmp.visible() == false then
                if fcall(fallback, luasnip.locally_jumpable(-1)) == false then
                    luasnip.jump(-1)
                end

                return
            end

            if luasnip.expandable() then
                luasnip.expand()
            else
                fcall(fallback, cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }))
            end
        end

        cmp_mappings["<C-S-Space>"] = function(fallback)
            if cmp.visible() then
                fcall(fallback, cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select }))
                return
            end

            fallback()
            -- fcall(fallback, cmp.complete())
        end

        cmp_mappings["<C-Space>"] = function(fallback)
            if cmp.visible() then
                fcall(fallback, cmp.select_next_item({ behavior = cmp.SelectBehavior.Select }))
                return
            end

            fcall(fallback, cmp.complete())
        end

        -- missing TypeParameter = ' '
        local filters = {}

        -- types
        table.insert(filters, { keymap = "<M-t>", filter = { "Class", "Struct", "Enum" } })
        table.insert(filters, { keymap = "<M-i>", filter = { "Interface" }})

        -- special methods
        table.insert(filters, { keymap = "<M-c>", filter = { "Constructor" }})
        table.insert(filters, { keymap = "<M-o>", filter = { "Operator" }})
        table.insert(filters, { keymap = "<M-e>", filter = { "Event" }})

        -- regular methods
        table.insert(filters, { keymap = "<M-m>", filter = { "Method", "Function" }})

        -- regular fields
        table.insert(filters, { keymap = "<M-f>", filter = { "Field", "Variable" }})

        -- constants
        table.insert(filters, { keymap = "<M-v>", filter = { "Value", "EnumMember", "Constant", "Color" }})

        table.insert(filters, { keymap = "<M-p>", filter = { "Property" }})
        table.insert(filters, { keymap = "<M-n>", filter = { "Module" }})
        table.insert(filters, { keymap = "<M-s>", filter = { "Snippet" }})

        _G.selected_cmp_filters = {}

        for _, entry in ipairs(filters) do
            local key = entry.keymap
            local kinds = entry.filter

            cmp_mappings[key] = function(fallback)
                if cmp.visible() == false then
                    fallback()
                    return
                end

                local filter_fn = function(entry)
                    local types = require("cmp.types")
                    local item_kind = types.lsp.CompletionItemKind[entry:get_kind()]

                    local count = 0
                    for filter, _ in pairs(_G.selected_cmp_filters) do
                        if vim.tbl_contains(filter, item_kind) == true then
                            return true
                        end

                        count = count + 1
                    end

                    -- return all items if selected filters empty
                    return count == 0 and true or false
                end

                if _G.selected_cmp_filters[kinds] ~= nil then
                    _G.selected_cmp_filters[kinds] = nil
                else
                    _G.selected_cmp_filters[kinds] = true
                end

                cmp.complete({
                    config =
                    {
                        sources =
                        {
                            {
                                name = "nvim_lsp",
                                entry_filter = filter_fn
                            }
                        }
                    }
                })

            end
        end

        vim.opt.pumheight = 15
        require("luasnip.loaders.from_snipmate").load()

        local cmp_enabled = true

        vim.api.nvim_create_autocmd("User", {
            pattern = "LuasnipInsertNodeEnter",
            callback = function() cmp_enabled = false end
        })
        vim.api.nvim_create_autocmd("User", {
            pattern = "LuasnipInsertNodeLeave",
            callback = function() cmp_enabled = true end
        })

        cmp.setup({
            enabled = function() return cmp_enabled end,

            completion = { completeopt = "menu,menuone,noinsert" },

            snippet =
            {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },

            window =
            {
                completion =
                {
                    side_padding = 0,
                    scrolloff = 1,
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None,FloatFooter:Pmenu",
                },
                documentation = {
                    -- TODO: should set to NormalFloat somewhere in ideal world
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                    max_width = 100
                }
            },

            mapping = cmp_mappings,

            formatting =
            {
                expandable_indicator = true,
                fields = { "kind", "abbr", "menu" },

                format = function(_, vim_item)
                    local item_width = 45
                    local trunk = vim_item.abbr:sub(1, item_width)
                    if #trunk ~= #vim_item.abbr then
                        vim_item.abbr = trunk .. "..."
                    end

                    if vim_item.abbr:len() < item_width then
                        vim_item.abbr = ("%s%s"):format(vim_item.abbr, (" "):rep(item_width - vim_item.abbr:len()))
                    end

                    vim_item.menu = ("[%s]"):format(vim_item.kind)
                    vim_item.kind = (" %s "):format(kind_icons[vim_item.kind])

                    return vim_item
                end
            },

            view =
            {
                entries = { name = "custom", selection_order = "near_cursor" },
                docs = { auto_open = true }
            },

            sources = cmp.config.sources(
            { { name = 'nvim_lsp_signature_help' }, },
            {
                { name = "luasnip" },
                { name = "conventionalcommits" },
                { name = "async_path" },
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "calc" }
            })
        })

        -- TODO: rewrite with public api? (hint: events)
        ---@diagnostic disable-next-line: invisible
        local old_open = cmp.core.view:_get_entries_view().entries_win.open

        ---@diagnostic disable-next-line: invisible
        cmp.core.view:_get_entries_view().entries_win.open = function(self, style)
            local api = require("cmp.utils.api")
            if api.is_cmdline_mode() then
                old_open(self, style)
                return
            end

            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            _G.cmp_entries_win_height = style.height

            -- cursor row relative to editor
            local absolute_row = vim.fn.screenpos(0, row, col).row

            if absolute_row ~= style.row then
                style.row = style.row - 1
            else
                if style.row + style.height > vim.o.lines - 2 then
                    _G.cmp_entries_win_height = vim.o.lines - style.row - 2
                end
            end

            local footer = {}

            for _, entry in ipairs(filters) do
                local key = entry.keymap
                local kinds = entry.filter

                local kind_icon = kind_icons[kinds[1]]
                local kind_key = key:sub(4, 4)

                local entry = (" %s%s "):format(kind_icon, kind_key)
                table.insert(footer, { entry, _G.selected_cmp_filters[kinds] == true and "CmpItemKind" or "StatusLine" })
            end

            -- TODO: completion window may overlap statusline because window
            --       can show less than `vim.o.pumheight` items and still
            --       render from top-to-bottom.
            --
            --       possible solution:
            --           if completion window start overlap statusline
            --           (i.e. style.height < vim.o.pumheight) it is necessary
            --           to open window in different direction.
            --
            --       main problems:
            --           1) style.height always equal vim.o.pumheight
            --              in `open()` method;
            --           2) need to find out how to open completion window in
            --              different direction.
            old_open(self, vim.tbl_extend("force", style,
            {
                footer = footer,
                footer_pos = "center",
                border = { "", "", "", "", "", { " ", "StatusLine" }, "", "" }
            }))
        end

        ---@diagnostic disable-next-line: invisible
        local old_update = cmp.core.view:_get_entries_view().entries_win.update

        ---@diagnostic disable-next-line: invisible
        cmp.core.view:_get_entries_view().entries_win.update = function(self)
            -- increase scrollbar in update() method because changing height
            -- before window construction (i.e. in open() method)
            -- changes the size of the main window.
            local api = require("cmp.utils.api")
            if api.is_cmdline_mode() == false then
                self.style.height = _G.cmp_entries_win_height + 1
            end
            old_update(self)
        end

        cmp.core.view.event:on("menu_closed", function()
            _G.selected_cmp_filters = {}
        end)

        local cmdline_mappings = {}
        for _, mapping in ipairs({ "<Tab>", "<C-Space>", "<C-S-Space>" }) do
            cmdline_mappings[mapping] = { c = cmp_mappings[mapping] }
        end

        local cmdline_formatting =
        {
            fields = { "kind", "abbr", "menu" },

            format = function(_, vim_item)
                vim_item.kind = " "
                return vim_item
            end
        }

        cmp.setup.cmdline(":",
        {
            mapping = cmdline_mappings,
            formatting = cmdline_formatting,
            sources = { { name = "cmdline" } }
        })
    end
}
