_G.preview_tagfunc = function(pattern, _)
    local glance = require("glance")
    glance.open("definitions")
    return {{ cmd = "", filename = vim.api.nvim_buf_get_name(0), name = pattern}}
end

return
{
    "DNLHC/glance.nvim",

    config = function()
        local glance = require("glance")
        local actions = glance.actions

        ---@diagnostic disable-next-line: missing-fields
        glance.setup({
            mappings =
            ---@diagnostic disable-next-line: missing-fields
            {
                list =
                {
                    ["<C-j>"] = actions.preview_scroll_win(-2),
                    ["<C-k>"] = actions.preview_scroll_win(2),
                    ["<C-x>"] = actions.jump_split,
                    ["<C-v>"] = actions.jump_vsplit,
                    ["<Tab>"] = actions.toggle_fold
                }
            }
        })

        vim.keymap.set("n", "<C-\\>", function() glance.open("implementations") end)

        -- TODO: create more meaningful keymaps for this features...
        vim.keymap.set("n", "gr", function() glance.open("references") end)
    end
}
