local M = {}

M.prettier = function()
    return {
        exe = "prettier",
        args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
        stdin = true,
    }
end

M.rustfmt = function()
    return {
        exe = "rustfmt",
        args = { "--emit=stdout" },
        stdin = true,
    }
end

M.stylua = function()
    return {
        exe = "stylua",
        args = {
            "--stdin-filepath",
            vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
            "--search-parent-directories",
            "--",
            "-",
        },
        stdin = true,
        cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h"),
    }
end

M.black = function()
    return {
        exe = "black", -- this should be available on your $PATH
        args = { "-" },
        stdin = true,
    }
end

M.terraform = function()
    return {
        exe = "terraform",
        args = { "fmt", "-" },
        stdin = true,
    }
end

M.shfmt = function()
    return {
        exe = "shfmt",
        args = { "-i", 4 },
        stdin = true,
    }
end

M.goimports = function()
    return {
        exe = "goimports",
        stdin = true,
        cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h"),
    }
end

M.golines = function()
    return {
        exe = "golines",
        stdin = true,
        cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h"),
    }
end

require("formatter").setup({
    logging = false,
    filetype = {
        go = { M.golines },
        javascript = { M.prettier },
        typescript = { M.prettier },
        typescriptreact = { M.prettier },
        rust = { M.rustfmt },
        lua = { M.stylua },
        python = { M.black },
        terraform = { M.terraform },
        sh = { M.shfmt },
        zsh = { M.shfmt },
        bash = { M.shfmt },
    },
})

local group = vim.api.nvim_create_augroup("local-with-formatter", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.js", "*.ts", "*.lua", "*.rs", "*.go", "*.sh", "*.zsh", "*.bash", "*.py", "*.tf" },
    group = group,
    command = "FormatWrite",
})

vim.keymap.set("n", "<leader>F", "<cmd>FormatWrite<cr>", { noremap = true, desc = "format current buffer and save" })

return M
