_G.preview_tagfunc = function(pattern, _)
    local glance = require("glance")
    glance.open("definitions")
    return {{ cmd = "", filename = vim.api.nvim_buf_get_name(0), name = pattern}}
end

return
{
    "DNLHC/glance.nvim", cmd = "Glance",
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
                    ["<C-v>"] = actions.jump_vsplit
                }
            }
        })

    end
}
