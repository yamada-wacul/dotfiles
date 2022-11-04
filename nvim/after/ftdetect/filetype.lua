local group = vim.api.nvim_create_augroup("local-ftdetect", {})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = group,
    pattern = "tsconfig.json",
    callback = function()
        vim.o.filetype = "jsonc"
    end,
})
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = group,
    pattern = "*.jax",
    callback = function()
        vim.o.filetype = "help"
    end,
})
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = group,
    pattern = { "*/.git/config", "*/.git/*.conf", "*/git/config", "*/git/*.conf" },
    callback = function()
        vim.o.filetype = "gitconfig"
    end,
})
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = group,
    pattern = { "*/.ssh/*.conf", "*/ssh/*.conf" },
    callback = function()
        vim.o.filetype = "sshconfig"
    end,
})
