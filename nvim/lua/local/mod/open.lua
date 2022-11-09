local M = {}

--- Open the file/url under the cursor with special handler (i.e. xdg-open, wslview, etc...)
function M.open_cursor()
    local target = vim.fn.expand("<cfile>")
    if target == nil then
        print("No target found at cursor.")
        return
    end
    target = string.gsub(target, [[\.+$]], "")
    if vim.loop.os_uname().sysname == "Darwin" == 1 then
        vim.fn.system('open ' .. vim.fn.shellescape(target))
    elseif vim.fn.executable("wslview") then
        vim.fn.system('wslview ' .. vim.fn.shellescape(target))
    elseif vim.fn.executable("xdg-open") then
        vim.fn.system('xdg-open ' .. vim.fn.shellescape(target))
    else
        vim.api.nvim_echo({ { "No executables to open file/url", "ErrorMsg" } }, true, {})
    end
end

vim.api.nvim_create_user_command("OpenCursor", M.open_cursor, {
    desc = "Open files or urls under the cursor by special handler",
})
vim.keymap.set("n", "<plug>(open-cursor-file)", M.open_cursor, {
    desc = "Open files or urls under the cursor by special handler",
    silent = true,
    noremap = true,
    nowait = true
})
