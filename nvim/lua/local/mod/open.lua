local M = {}

function M.open()
    local target = vim.fn.expand("<cfile>")
    if target == nil then
        print("No target found at cursor.")
        return
    end
    target = string.gsub(target, [[\.+$]], "")
    if vim.fn.has("macunix") == 1 then
        vim.cmd(string.format('silent! !open "%s"', target))
        vim.cmd("silent! redraw")
    elseif vim.fn.executable("wslview") then
        vim.cmd(string.format('silent! !wslview "%s"', target))
        vim.cmd("silent! redraw")
    elseif vim.fn.executable("xdg-open") then
        vim.cmd(string.format('silent! !xdg-open "%s"', target))
        vim.cmd("silent! redraw")
    else
        vim.api.nvim_echo({ { "No executables to view file/url", "ErrorMsg" } }, true, {})
    end
end

return M
