return
{
    "lukas-reineke/virt-column.nvim",
    config = function()
        require("virt-column").setup({})
        vim.opt.colorcolumn = "80"
    end
}
