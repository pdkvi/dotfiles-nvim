---@param path string
local function startscreen_cd(path)
    vim.cmd("tcd " .. path)
    require("nvim-tree.api").tree.open()
end

return
{
    "echasnovski/mini.starter",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
        local starter = require("mini.starter")

        ---@diagnostic disable-next-line: undefined-field
        local username = vim.loop.os_get_passwd()["username"] or "stranger"

        starter.setup({
            header = ("welcome, %s."):format(username),

            items =
            {
                function()
                    local path = require("plenary.path")
                    local scan = require("plenary.scandir")

                    local section = "Projects"

                    ---@type Path
                    local projects_dir = path:new(path.path.home, "Projects")

                    local entries = {}

                    local projects = scan.scan_dir(projects_dir.filename, { add_dirs = true, depth = 1, })

                    for _, project in ipairs(projects) do
                        table.insert(entries,
                        {
                            section = section,
                            name = path:new(project):normalize(projects_dir.filename),
                            action = function() startscreen_cd(project) end
                        })
                    end

                    return entries
                end,

                function()
                    local section = "Miscellaneous"

                    local entries =
                    {
                    }


                    vim.iter(entries):each(function(entry) entry.section = section end)
                    return entries
                end,

                function()
                    local section = "Editor"
                    local entries =
                    {
                        {
                            name = "Edit configuration",
                            action = function() startscreen_cd("~/.config/nvim") end
                        },

                        {
                            name = "View plugins directory",
                            action = function() startscreen_cd("~/.local/share/nvim/lazy") end
                        },

                        {
                            name = "Manage plugins",
                            action = function() require("lazy").home() end
                        },

                        { name = "Quit", action = function() vim.cmd("qa") end }
                    }

                    vim.iter(entries):each(function(entry) entry.section = section end)
                    return entries
                end
            },
        })

        vim.api.nvim_create_user_command("StarterOpen", function() starter.open(nil) end, {})
    end
}
