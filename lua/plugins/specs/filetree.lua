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

        -- vvv god bless this mess vvv

        local complete_fn = function(arg)
            return vim.tbl_filter(function(str)
                return str:match("^" .. arg)
            end, { "enable", "disable" })
        end

        vim.api.nvim_create_user_command("CMakeAutoInsert", function(opts)
            _G.cmake_autoinsert_enabled = opts.args == "enable" and true or false
        end, { nargs = 1, complete = complete_fn })

        _G.cmake_autoinsert_enabled = true

        local Event = api.events.Event
        api.events.subscribe(Event.FileCreated, function(data)
            if _G.cmake_autoinsert_enabled == false then return end

            ---@type string
            local filename = vim.fs.basename(data.fname)
            if filename:find(".+%.c$") == nil and filename:find(".+%.cpp$") == nil then
                return
            end

            local cwd = vim.uv.cwd() .. "/"
            local rpath = data.fname

            local Path = require("plenary.path")
            while true do
                ::continue::
                rpath = rpath:match("(.*/).+$")
                if #rpath < #cwd then
                    vim.notify(
                        ("Unable to add '%s' to any CMakeLists.txt"):format(filename),
                        vim.log.levels.INFO, { title = "CMake" }
                    )
                    break
                end

                local cmakelists_path = rpath .. "CMakeLists.txt"
                if Path:new(cmakelists_path):exists() == false then
                    goto continue
                end

                local file = assert(io.open(cmakelists_path, "r+"))
                local lines = {}

                local it = file:lines()
                for line in it do
                    if line:find("^%s*target_sources%s*%(") ~= nil then
                        local ins_pos = line:find("%)%s*$")
                        if ins_pos ~= nil then
                            line = line:gsub("%)%s*$", (' "%s")'):format(data.fname:gsub(rpath, "./")))
                            table.insert(lines, line)
                            goto insertion_complete
                        end

                        table.insert(lines, line)

                        if line:find("\"?.+%.c\"?") or
                           line:find("\"?.+%.cpp\"?")
                        then
                            table.insert(lines, ('\t"%s"'):format(data.fname:gsub(rpath, "./")))
                            goto insertion_complete
                        end

                        for subline in it do
                            table.insert(lines, subline)

                            if subline:find("\"?.+%.c\"?") or
                               subline:find("\"?.+%.cpp\"?")
                            then
                                table.insert(lines, ('\t"%s"'):format(data.fname:gsub(rpath, "./")))
                                goto insertion_complete
                            end
                        end
                    else
                        table.insert(lines, line)
                    end
                end

                file:close()
                goto continue

                ::insertion_complete::
                for line in it do
                    table.insert(lines, line)
                end

                file:seek("set", 0)
                for _, line in ipairs(lines) do file:write(line .. "\n") end

                file:close()

                vim.notify(
                    ("File '%s' added to '%s'"):format(filename, cmakelists_path:gsub(cwd, "./")),
                    vim.log.levels.INFO, { title = "CMake" }
                )

                vim.cmd("checktime")
                break
            end
        end)
    end
}
