vim.api.nvim_create_autocmd("ExitPre", {
    group = vim.api.nvim_create_augroup("local-etc-quitable", {}),
    callback = function()
        require("local.etc.quitable").quit_empty_buffers()
    end,
})
