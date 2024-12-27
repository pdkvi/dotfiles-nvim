return
{
    "rcarriga/nvim-notify",

    config = function()
        local notify = require("notify")

        ---@diagnostic disable-next-line: missing-fields
        notify.setup({
            icons =
            {
                DEBUG = " ",
                ERROR = " ",
                INFO = " ",
                TRACE = "✎ ",
                WARN = " "
            },

            timeout = 500
        })

        vim.notify = notify
    end
}
