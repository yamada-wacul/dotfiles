-- テキストの編集と表示に関する設定
local tab_size = 4
vim.opt.tabstop = tab_size
vim.opt.shiftwidth = tab_size
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    command = "setlocal tabstop=4 shiftwidth=4",
    group = vim.api.nvim_create_augroup("local-etc-text", {}),
})
--
--
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true

vim.opt.wrap = false
vim.opt.textwidth = 0 -- never limit length of each line

vim.opt.ambiwidth = "single"
vim.opt.emoji = true -- Show emoji characters
vim.opt.conceallevel = 0
vim.opt.foldmethod = "manual"
vim.opt.list = true
vim.opt.listchars = {
    tab = "» ",
    trail = "▫",
    eol = "↵",
    extends = "⍄",
    precedes = "⍃",
    nbsp = "∙",
}

vim.opt.fixendofline = true -- <EOL> at the end of file will be restored if missing
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.formatoptions:append("o") -- Automatically insert the current comment leader after hitting 'o' or 'O'
vim.opt.formatoptions:append("j") -- Delete comment character when joining commented lines
