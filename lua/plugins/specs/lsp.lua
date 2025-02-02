return
{
    "neovim/nvim-lspconfig",
    dependencies =
    {
        {
            "folke/lazydev.nvim", ft = "lua",
            dependencies = { "Bilal2453/luvit-meta", lazy = true },
            opts =
            {
                library =
                {
                    { path = "luvit-meta/library", words = { "vim%.uv" }}
                }
            }
        },
        -- "Issafalcon/lsp-overloads.nvim"
    },

    config = function()
        local lspconfig = require("lspconfig")

        vim.keymap.set("n", "<C-j>", "<C-e>")
        vim.keymap.set("i", "<C-j>", "")

        vim.keymap.set("n", "<C-k>", "<C-y>")
        vim.keymap.set("i", "<C-k>", "")

        vim.keymap.set("n", "<A-CR>", vim.lsp.buf.code_action)
        vim.keymap.set({"i", "n"}, "<F2>", vim.lsp.buf.rename)

        -- <C-i> = \u{f7fe}
        vim.keymap.set("n", "<S-i>", vim.lsp.buf.hover)

        vim.keymap.set("n", "K", function()
            local float_bufnr, win_id = vim.diagnostic.open_float()
            if float_bufnr == nil and win_id == nil then
                vim.lsp.buf.hover()
            end
        end)

        local signs =
        {
            [vim.diagnostic.severity.ERROR] = '▓',
            [vim.diagnostic.severity.WARN]  = '▓',
            [vim.diagnostic.severity.HINT]  = '▓',
            [vim.diagnostic.severity.INFO]  = '▓',
        }

        local handlers =
        {
            ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
            ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
        }

        vim.diagnostic.config({
            virtual_text = { spacing = 0 },
            signs = { text = signs },
            float = { border = "rounded" }
        })

        for type, icon in pairs(signs) do
            local hl = "LspDiagnosticsSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
        }

        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            handlers = handlers,
            settings =
            {
                Lua =
                {
                    diagnostics =
                    {
                        disable =
                        {
                            "redefined-local", "redundant-return-value"
                        }
                    }
                }
            }
        })

        --lspconfig.ccls.setup({
            --	capabilities = capabilities,
            --	init_options = {
                --		cache = { directory = vim.fs.normalize("~/.cache/ccls") }
                --	}
                --})
                lspconfig.clangd.setup({
                    handlers = handlers,
                    capabilities = capabilities,
                    cmd =
                    {
                        "clangd",
                        "--header-insertion=never",
                        "-j=4",
                        "--malloc-trim",
                        "--background-index",
                        "--pch-storage=memory"
                    }
                })

                lspconfig.neocmake.setup({
                    handlers = handlers,
                    capabilities = capabilities
                })
            end
        }
