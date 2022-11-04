vim.opt.cursorline = true -- Highlight cursor line
vim.opt.cursorlineopt = "number,line" -- Highlight cursor line (only number)

local group = vim.api.nvim_create_augroup("local-etc-cursorline", {})
local function en()
    vim.wo.cursorline = true
end
local function dis()
    vim.wo.cursorline = false
end

vim.api.nvim_create_autocmd("VimEnter", { group = group, callback = en })
vim.api.nvim_create_autocmd("WinEnter", { group = group, callback = en })
vim.api.nvim_create_autocmd("BufWinEnter", { group = group, callback = en })
vim.api.nvim_create_autocmd("WinLeave", { group = group, callback = dis })
