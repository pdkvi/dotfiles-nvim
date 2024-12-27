return
{
    "folke/trouble.nvim",
    config = function()
        local trouble = require("trouble")
        trouble.setup({
            open_no_results = true,
            warn_no_results = false,

            modes =
            {
                lsp_references = {
                    params = { include_declarations = false }
                },

                lsp_base = {
                    params = { auto_jump = false }
                }
            }
        })
        vim.keymap.set("n", "<leader>d", "<cmd>Trouble diagnostics toggle<cr>")
        vim.keymap.set("n", "<leader>o", "<cmd>Trouble lsp_document_symbols toggle<cr>")

        vim.keymap.set("n", "<leader>cr", "<cmd>Trouble lsp_references toggle<cr>")

        ---@param name string
        ---@return vim.api.keyset.highlight
        local function hl(name)
            ---@diagnostic disable-next-line: return-type-mismatch
            return vim.api.nvim_get_hl(0, { name = name, link = false })
        end

        -- vim.api.nvim_set_hl(0, "TroubleCount", { fg = hl("TabLineSel").fg })
        vim.api.nvim_set_hl(0, "TroubleIndent", { fg = hl("LineNr").fg })
        vim.api.nvim_set_hl(0, "TroublePos", { fg = hl("LineNr").fg })

        vim.api.nvim_set_hl(0, "TroubleNormal", { link = "TroubleNormal" })
        vim.api.nvim_set_hl(0, "TroubleNormalNC", { link = "TroubleNormalNC" })
    end
}
