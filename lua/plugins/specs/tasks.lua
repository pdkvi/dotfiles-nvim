return
{
    "Civitasv/cmake-tools.nvim",
    config = function()
        local cmake = require("cmake-tools")
        cmake.setup({
            cmake_regenerate_on_save = false,
            cmake_dap_configuration = { type = "lldb" }
        })

        vim.api.nvim_create_autocmd("DirChanged",
        {
            callback = function()
                local cwd = vim.uv.cwd()
                local file = io.open(vim.fs.normalize(cwd .. "/CMakeLists.txt"), "r")
                if file == nil then return end
                file:close()

                local Config = require("cmake-tools.config")
                local config = Config:new(require("cmake-tools.const"))

                Config.cwd = vim.fn.resolve(cwd)
                cmake.register_scratch_buffer(config.executor.name, config.runner.name)

                vim.notify("Changed project root directory to " .. Config.cwd, nil, {
                    title = "CMake"
                })
            end
        })

        vim.keymap.set("n", "<F3>", function() cmake.generate({}) end)

        vim.keymap.set("n", "<F7>", function()
            cmake.select_launch_target(false, function()
                cmake.build({ target = cmake.get_launch_target() })
            end)
        end)
    end
}
