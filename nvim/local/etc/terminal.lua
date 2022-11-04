-- ターミナルを便利にする
local function attempt_set_shell(shell)
    if vim.fn.filereadable(shell) then
        vim.o.shell = shell
        vim.env.SHELL = shell
    end
end

attempt_set_shell("/usr/local/bin/zsh")
attempt_set_shell("/usr/bin/zsh")
attempt_set_shell("/bin/zsh")

vim.o.termguicolors = true

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("local-etc-terminal", {}),
    pattern = "term://*",
    callback = function()
        require("local.etc.terminal").setup()
    end,
})

vim.env.NVIM_TERMINAL = 1
