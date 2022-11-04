local function tab_leave()
    vim.t.tabwin_last_winnr = vim.api.nvim_get_current_win()
end

local function tab_enter()
    local last_winnr = vim.t.tabwin_last_winnr
    if last_winnr == nil then
        return
    end
    pcall(vim.api.nvim_set_current_win, last_winnr)
end

local group = vim.api.nvim_create_augroup("local-mod-tabwin", {})
vim.api.nvim_create_autocmd("TabLeave", {
    group = group,
    callback = tab_leave,
})
vim.api.nvim_create_autocmd("TabEnter", {
    group = group,
    callback = tab_enter,
})
