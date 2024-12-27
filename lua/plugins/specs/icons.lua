return
{
    "echasnovski/mini.icons", priority = 900,
    config = function()
        local icons = require("mini.icons")
        icons.setup()
        icons.mock_nvim_web_devicons()
    end
}
