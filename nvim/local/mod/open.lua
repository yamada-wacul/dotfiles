require("local.mod.open")
vim.keymap.set("n", "gx", "<plug>(open-cursor-file)", { desc = "Open files or urls under the cursor by special handler" })

vim.keymap.set("n", "gf", 'gF', { remap = false })
vim.keymap.set("n", "gfv", [[<cmd>vertical wincmd F<cr>]], { remap = false })
vim.keymap.set("n", "gfx", [[<cmd>horizontal wincmd F<cr>]], { remap = false })
