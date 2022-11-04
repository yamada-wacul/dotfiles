local function save_as(e)
    local newname = e.fargs[1]
    local oldname = vim.api.nvim_buf_get_name(0)
    vim.cmd("saveas" .. (e.bang and "! " or " ") .. newname)
    vim.fn.delete(oldname)
    vim.cmd("silent! edit")
end

vim.api.nvim_create_user_command("SaveAs", save_as, {
    force = true,
    bang = true,
    bar = true,
    complete = "file",
    nargs = 1,
})
