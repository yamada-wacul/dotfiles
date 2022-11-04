-- コマンドラインをカスタマイズ
vim.keymap.set("c", "<C-A>", "<Home>", { noremap = true, desc = "cursor to beginning of command-line" })
vim.keymap.set("c", "<C-F>", "<Right>", { noremap = true, desc = "cursor right" })
vim.keymap.set("c", "<C-B>", "<Left>", { noremap = true, desc = "cursor left" })
vim.keymap.set("c", "<C-D>", "<Del>", {
    noremap = true,
    desc = "delete the character under the cursor (at end of line: character before the cursor)"
})
vim.keymap.set("c", "<C-H>", "<BS>", { noremap = true, desc = "delete the character in front of the cursor" })

-- Go back command histories with prefix in the command
vim.keymap.set("c", "<C-P>", "<Up>", {
    noremap = true,
    desc = "recall older command-line from history, whose beginning matches the current command-line (see below)"
})
vim.keymap.set("c", "<C-N>", "<Down>", {
    noremap = true,
    desc = "recall more recent command-line from history, whose beginning matches the current command-line (see below)"
})

-- enter command-line-window
vim.opt.cedit = vim.api.nvim_replace_termcodes("<c-y>", true, true, true)
