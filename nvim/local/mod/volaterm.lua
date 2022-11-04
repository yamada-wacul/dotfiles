local group = vim.api.nvim_create_augroup("local-mod-volaterm-mode", {})
vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "term://*",
    group = group,
    callback = function()
        require("local.mod.volaterm").save_mode()
    end,
})
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "term://*",
    group = group,
    callback = function()
        require("local.mod.volaterm").restore_mode()
    end,
})
vim.api.nvim_create_autocmd("TermOpen", {
    group = group,
    pattern = "term://*",
    callback = function()
        if vim.b.volaterm == 1 then
            vim.cmd("startinsert")
        end
    end,
})

-- ターミナルをさっと開く
--   サイズ指定付き: 80tx 15tv
vim.keymap.set("n", "tt", function()
    require("local.mod.volaterm").open()
end, { noremap = true, silent = true, desc = "open a terminal in the current window" })
vim.keymap.set("n", "tx", function()
    require("local.mod.volaterm").split(0, "")
end, { noremap = true, silent = true, desc = "open a terminal in a splitted window" })
vim.keymap.set("n", "tv", function()
    require("local.mod.volaterm").split(0, "vertical")
end, { noremap = true, silent = true, desc = "open a terminal in a vertical-splitted window" })
vim.keymap.set("n", "tct", function()
    require("local.mod.volaterm").open({ cwd = vim.fn.expand("%:p:h") })
end, { noremap = true, silent = true, desc = "open a terminal in the current window from current working directory" })
vim.keymap.set("n", "tcx", function()
    require("local.mod.volaterm").split(0, "", { cwd = vim.fn.expand("%:p:h") })
end, { noremap = true, silent = true, desc = "open a terminal in a splitted window from current working directory" })
vim.keymap.set("n", "tcv", function()
    require("local.mod.volaterm").split(0, "vertical", { cwd = vim.fn.expand("%:p:h") })
end, {
    noremap = true, silent = true,
    desc = "open a terminal in a vertical-splitted window from current working directory"
})
