return
{
    "nvim-tree/nvim-tree.lua", opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            hijack_cursor = true,
            sync_root_with_cwd = true,
            select_prompts = true,

            view =
            {
                preserve_window_proportions = true,
                width = 45
            },

            renderer =
            {
                special_files = {},
                highlight_modified = "name",

                indent_width = 2,
                indent_markers = { enable = true, },

                icons =
                {
                    padding = "  ",
                    symlink_arrow = "   ",

                    glyphs =
                    {
                        modified = "[+]",
                        folder =
                        {
                            arrow_closed = " ",
                            arrow_open = " ",
                        },
                        git =
                        {
                            unstaged = "",
                            staged = "󰄵",
                            unmerged = "",
                            renamed = "",
                            untracked = "",
                            deleted = "",
                            ignored = "",
                        }
                    }
                }
            },

            filters = { custom = { "^\\.git$", "^out$" } },

            filesystem_watchers =
            {
                enable = true,
                debounce_delay = 50,
                ignore_dirs =
                {
                    "/.cache",
                    "/.ccls-cache",
                    "/build",
                    "/out",
                    "/node_modules",
                    "/target",
                },
            },

            modified = { enable = true },

            notify = { threshold = vim.log.levels.WARN }
        })

        local api = require("nvim-tree.api")
        vim.keymap.set("n", "<leader>e", api.tree.toggle, { desc = "Toggle filesystem tree" })

        vim.api.nvim_create_autocmd("DirChanged",
        {
            pattern = "window",
            callback = function(opts)
                local ft = vim.api.nvim_get_option_value("filetype", { buf = opts.buf })
                if ft == "NvimTree" then
                    vim.cmd("tcd " .. opts.file)
                end
            end
        })
    end
}
