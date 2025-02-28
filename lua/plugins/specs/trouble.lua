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
    end
}
