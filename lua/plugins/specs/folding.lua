return
{
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },

    config = function()
        -- todo: clean this dirty hack...
        vim.keymap.set({"n", "i"}, "\u{f7ff}\u{f7ff}", function() vim.cmd("silent! normal za") end)
        vim.keymap.set("i", "\u{f7ff}", "")
        -- vim.keymap.set("n", "<C-m><C-m>", "za")

        vim.opt.foldcolumn = "1"
        vim.opt.foldlevel = 99
        vim.opt.foldenable = true

        local ufo = require("ufo")
        ufo.setup({
            open_fold_hl_timeout = 0,

            provider_selector = function(_, _, _)
                return function(bufnr)
                    ---@param folds UfoFoldingRange[]
                    local function add_marker_folds(folds)
                        return vim.list_extend(folds, ufo.getFolds(bufnr, "marker"))
                    end

                    return ufo.getFolds(bufnr, "lsp"):thenCall(
                        add_marker_folds,
                        function()
                            local indent_folds = ufo.getFolds(bufnr, "indent")
                            return add_marker_folds(indent_folds)
                        end
                    )
                end
            end,

            fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = (" 󰁂 %d %s more..."):format(endLnum - lnum, endLnum - lnum == 1 and "line" or "lines")
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, {chunkText, hlGroup})
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, {suffix, "MoreMsg"})
                return newVirtText
            end
        })
    end
}
