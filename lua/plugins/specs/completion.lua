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
                fcall(fallback, cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }))
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
                fcall(fallback, cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }))
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

                    for filter, _ in pairs(_G.selected_cmp_filters) do
                        if vim.tbl_contains(filter, item_kind) == true then
                            return true
                        end
                    end

                    return false
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

        cmp.setup({
            completion = { completeopt = "menu,menuone,noinsert" },

            snippet =
            {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },

            window = {
                completion = { side_padding = 0 },
                documentation = {
                    -- TODO: should set to NormalFloat somewhere in ideal world
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                }
            },

            mapping = cmp_mappings,

            formatting =
            {
                expandable_indicator = true,
                fields = { "kind", "abbr", "menu" },

                format = function(_, vim_item)
                    local trunk = vim_item.abbr:sub(1, 70)
                    if #trunk ~= #vim_item.abbr then
                        vim_item.abbr = trunk .. "..."
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
}
