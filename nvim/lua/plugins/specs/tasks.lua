return
{
    "Civitasv/cmake-tools.nvim",
    dependencies = { {"akinsho/toggleterm.nvim", opts = { direction = "horizontal" }} },

    config = function()
        local const = vim.tbl_extend("force", require("cmake-tools.const"),
        {
            cmake_regenerate_on_save = false,
            cmake_generate_options =
            {
                "-GNinja",

                "-DCMAKE_C_COMPILER=clang",
                "-DCMAKE_CXX_COMPILER=clang++",

                "-DCMAKE_COLOR_DIAGNOSTICS=ON",

                "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
            },
            cmake_dap_configuration = { type = "lldb" },
            cmake_executor = {
                name = "toggleterm",
                default_opts =
                {
                    toggleterm =
                    {
                        direction = "horizontal", -- 'vertical' | 'horizontal' | 'tab' | 'float'
                        close_on_exit = false, -- whether close the terminal when exit
                        auto_scroll = true, -- whether auto scroll to the bottom
                        singleton = true, -- single instance, autocloses the opened one, if present
                    },
                }
            },

            cmake_notifications =
            {
                runner = { enabled = false },
                executor = { enabled = false }
            },

            cmake_virtual_text_support = false
        })

        local cmake = require("cmake-tools")
        cmake.setup(const)

        vim.api.nvim_create_autocmd("DirChanged",
        {
            callback = function()
                local cwd = vim.uv.cwd()
                local file = io.open(vim.fs.normalize(cwd .. "/CMakeLists.txt"), "r")
                if file == nil then return end
                file:close()

                local config = cmake.get_config()

                config.cwd = vim.fn.resolve(cwd)
                config:update_build_dir(const.cmake_build_directory, const.cmake_build_directory)
                cmake.register_scratch_buffer(config.executor.name, config.runner.name)

                vim.notify("Changed project root directory to " .. config.cwd, nil, {
                    title = "CMake"
                })
            end
        })

        vim.keymap.set("n", "<F3>", function() cmake.generate({}) end)

        vim.keymap.set("n", "<F7>", function()
            cmake.build({ target = "all" })
        end)

        vim.keymap.set("n", "<F19>", function()
            cmake.build({ target = nil })
        end)

        vim.keymap.set("n", "<F29>", function()
            local co = coroutine.create(function()
                local co = coroutine.running()

                if cmake.get_build_target() == nil then
                    cmake.build({ target = nil }, function()
                        coroutine.resume(co)
                    end)

                    coroutine.yield()
                end

                vim.system({
                    "xdg-terminal-exec", "bash", "-c",
                    cmake.get_build_target_path() .. " ; " ..
                    "printf '\\nPress any key to continue...'" .. " && " ..
                    "read -sr -n 1"
                })
            end)

            coroutine.resume(co)
        end)
    end
}
