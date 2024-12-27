return
{
    "stevearc/dressing.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
        require("dressing").setup({
            input =
            {
                relative = "cursor",
                prefer_width = 0
            },

            select =
            {
                backend = { "builtin" },
                builtin =
                {
                    relative = "cursor",
                    min_width = { 0, 0.1 },
                    min_height = { 0, 0.0 },
                    override = function(conf)
                        conf.width =  conf.width + 2
                        return conf
                    end
                }
            }
        })
    end
}
