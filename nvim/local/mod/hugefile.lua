local function check_huge_file()
    local name = vim.api.nvim_buf_get_name(0)
    local threshold_fsize = 500 * 1024
    local fsize = vim.fn.getfsize(name)

    if fsize <= threshold_fsize then
        return
    end
    local msg = string.format('"%s" is huge file.(%s byte) Which will you do?', name, fsize)
    local choices = {
        "&Abort",
        "&Open as usual",
        "Open as &simple",
        "&Quit vim instance",
    }
    local result = vim.fn.confirm(msg, table.concat(choices, "\n"))
    if result == 0 then -- Abort by interrupt key (like CTRL-c)
        vim.fn.interrupt()
    elseif result == 1 then -- 'Abort'
        vim.fn.interrupt()
    elseif result == 2 then -- 'Open'
        return
    elseif result == 2 then -- 'Simple'
        vim.cmd("syntax off")
    else
        vim.cmd("silent! quit")
    end
end

vim.api.nvim_create_autocmd("BufReadPre", {
    group = vim.api.nvim_create_augroup("local-mod-hugefile", {}),
    callback = check_huge_file,
})
