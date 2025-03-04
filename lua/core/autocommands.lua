-- disable comments continuation
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function() vim.opt.formatoptions:remove({ "r", "o" }) end
})

vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.cmd("setlocal scrolloff=0")
    end
})

-- restore cursor position
vim.api.nvim_create_autocmd('BufRead',
{
    callback = function(opts)
        vim.api.nvim_create_autocmd('BufWinEnter',
        {
            once = true,
            buffer = opts.buf,
            callback = function()
                local ft = vim.bo[opts.buf].filetype
                local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
                if
                    not (ft:match('commit') and ft:match('rebase'))
                    and last_known_line > 1
                    and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
                    then
                        vim.api.nvim_feedkeys([[g`"]], 'nx', false)
                    end
                end,
            })
        end,
    })

    return false
