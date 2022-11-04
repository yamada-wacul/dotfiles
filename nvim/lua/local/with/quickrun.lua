vim.g.quickrun_config = {
    mongo = {
        command = "mongosh",
        cmdopt = "--nodb --quiet",
        runner = "terminal",
    },
    lua = {
        type = "lua/vim",
        outputter = "message",
    },
    vim = {
        command = "source",
        runner = "vimscript",
        outputter = "message",
    },
}

local group = vim.api.nvim_create_augroup("local-with-quickrun", { clear = true })
vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*.mongo.js",
    group = group,
    callback = function()
        vim.b.quickrun_config = { type = "mongo" }
    end,
})
