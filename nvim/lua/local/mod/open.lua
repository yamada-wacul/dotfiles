local M = {}

function M.open()
    local target = vim.fn.expand("<cWORD>")
    if target == nil then
        print("No target found at cursor.")
        return
    end
    target = string.gsub(target, [[\.+$]], "")
    if vim.fn.has("macunix") == 1 then
        vim.cmd(string.format('silent! !open "%s"', target))
    else
        vim.cmd(string.format('silent! !xdg-open "%s"', target))
    end
end

return M
