local buffers = require("plugins.specs.telescope.buffers")

return
{
    "nvim-telescope/telescope.nvim", branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        local common_mappings = {}
        common_mappings["<C-d>"] = actions.delete_buffer
        common_mappings["<C-k>"] = actions.preview_scrolling_up
        common_mappings["<C-j>"] = actions.preview_scrolling_down

        telescope.setup({
            defaults =
            {
                file_ignore_patterns = { "out" },

                mappings =
                {
                    n = common_mappings,
                    i = vim.tbl_extend("keep", common_mappings,
                    {
                        ["<C-Space>"] = actions.move_selection_previous,
                        ["<C-S-Space>"] = actions.move_selection_next,
                    })
                }
            }
        })

        telescope.load_extension("notify")

        local builtin = require('telescope.builtin')
        vim.keymap.set("n", "<leader>fn", telescope.extensions.notify.notify)
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', function() buffers({ excluded_bt = { "terminal" } }) end, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>fm', function() builtin.man_pages({ sections = { "ALL" } }) end, {})
    end
}
