return
{
    "mfussenegger/nvim-dap",
    dependencies =
    {
        {
            "rcarriga/nvim-dap-ui",
            dependencies = { "nvim-neotest/nvim-nio" }
        }
    },

    init = function()
        local dap = require("dap")

        -- hl with diagnostic info
        vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error" })
        vim.fn.sign_define("DapLogPoint", { text = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "Error" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "Error" })

        vim.fn.sign_define("DapStopped", { text = " ", texthl = "DapStoppedText", linehl = "DapStoppedLine" })

        vim.keymap.set("n", "<F5>", dap.continue)
        vim.keymap.set("n", "<F17>", dap.terminate)

        vim.keymap.set("n", "<F9>", dap.toggle_breakpoint)

        vim.keymap.set("n", "<F10>", dap.step_over)
        vim.keymap.set("n", "<F11>", dap.step_into)
        vim.keymap.set("n", "<F12>", dap.step_out)

        dap.adapters.lldb =
        {
            type = "executable",
            command = "lldb-dap"
        }

        dap.configurations.cpp =
        {
            {
                name = "Launch",
                type = "lldb",
                request = "launch",
                program = function()
                    local cwd = vim.fn.getcwd()
                    local file = io.open(cwd .. "/CMakeLists.txt", "r")
                    if file == nil then
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end
                    file:close()

                    local cmake = require("cmake-tools")

                    local co = coroutine.running()
                    cmake.select_launch_target(false, function() coroutine.resume(co) end)
                    coroutine.yield()

                    return cmake.get_launch_target_path()
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false
            }
        }

        dap.configurations.c = dap.configurations.cpp

        local dapui = require("dapui")
        dapui.setup({
            controls =
            {
                element = "repl",
                enabled = false,
                icons = {
                    disconnect = "",
                    pause = "",
                    play = "",
                    run_last = "",
                    step_back = "",
                    step_into = "",
                    step_out = "",
                    step_over = "",
                    terminate = ""
                }
            },

            element_mappings = {},
            expand_lines = true,

            floating =
            {
                border = "rounded",
                mappings = { close = { "q", "<Esc>" } }
            },

            force_buffers = true,

            icons =
            {
                collapsed = "",
                current_frame = " ",
                expanded = ""
            },

            layouts =
            {
                {
                    elements =
                    {
                        {
                            id = "scopes",
                            size = 0.80
                        },

                        {
                            id = "breakpoints",
                            size = 0.20
                        }
                    },

                    position = "left",
                    size = 0.25
                },

                {
                    elements =
                    {
                        {
                            id = "stacks",
                            size = 0.8
                        },

                        {
                            id = "watches",
                            size = 0.2
                        },
                    },

                    position = "right",
                    size = 0.25
                },

                {
                    elements =
                    {
                        {
                            id = "repl",
                            size = 0.5
                        },
                        {
                            id = "console",
                            size = 0.5
                        }
                    },

                    position = "bottom",
                    size = 0.20
                }
            },

            mappings =
            {
                edit = "e",
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                repl = "r",
                toggle = "t"
            },

            render =
            {
                indent = 1,
                max_value_lines = 100
            }

        })

        local dapui_open = function()
            local filetree = require("nvim-tree.api").tree
            _G.dapui_closed_filetree = filetree.is_visible()

            if _G.dapui_closed_filetree == true then
                filetree.close_in_this_tab()
            end

            dapui.open()
        end

        local dapui_close = function()
            dapui.close()

            if _G.dapui_closed_filetree == true then
                local filetree = require("nvim-tree.api").tree
                filetree.open()
            end
        end

        dap.listeners.before.attach.dapui_config = dapui_open
        dap.listeners.before.launch.dapui_config = dapui_open

        dap.listeners.before.event_terminated.dapui_config = dapui_close
        dap.listeners.before.event_exited.dapui_config = dapui_close
    end
}
