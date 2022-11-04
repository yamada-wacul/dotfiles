-- キーマップの一覧をいい感じに表示する
vim.api.nvim_create_user_command("Nmaps", function()
    require("local.mod.keymaps").show_keymaps("n")
end, { force = true })
vim.api.nvim_create_user_command("Imaps", function()
    require("local.mod.keymaps").show_keymaps("i")
end, { force = true })
vim.api.nvim_create_user_command("Vmaps", function()
    require("local.mod.keymaps").show_keymaps("v")
end, { force = true })
vim.api.nvim_create_user_command("Omaps", function()
    require("local.mod.keymaps").show_keymaps("o")
end, { force = true })
vim.api.nvim_create_user_command("Tmaps", function()
    require("local.mod.keymaps").show_keymaps("t")
end, { force = true })
