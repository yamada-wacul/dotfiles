-- 補完とスニペットの設定
vim.opt.completeopt = { "menuone", "noinsert" }
local cmp = require("cmp")

-- テキスト内の補完: lsp, vsnip
cmp.setup({
    enabled = true,
    preselect = cmp.PreselectMode.Item,
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable,
        ["<CR>"] = {
            i = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ select = false }),
        },
    }),
    completion = {
        autocomplete = false,
        keyword_length = 0,
    },
    experimental = {
        ghost_text = true,
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "vsnip" },
    }),
})

vim.keymap.set({ "i", "c" }, "<C-x><C-s>", cmp.complete, { noremap = true, desc = "start completion" })
vim.keymap.set({ "i", "c" }, "<C-s>", cmp.complete, { noremap = true, desc = "start completion" })

-- コマンドラインの補完: パス、過去のcmdline
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})

-- snippetsの設定
vim.g.vsnip_snippet_dirs = {
    vim.fn.expand("~/.config/nvim/vsnip"),
    vim.fn.expand("~/.config/aia/vsnip"),
}

-- Expand, jump forward or backward
local expand = function()
    return vim.fn["vsnip#available"](1) == 0 and "<c-l>" or "<plug>(vsnip-expand-or-jump)"
end
local jump_next = function()
    return vim.fn["vsnip#jumpable"](1) == 0 and "<tab>" or "<plug>(vsnip-jump-next)"
end
local jump_prev = function()
    return vim.fn["vsnip#jumpable"](-1) == 0 and "<s-tab>" or "<plug>(vsnip-jump-prev)"
end
vim.keymap.set("i", "<c-l>", expand, { expr = true, desc = "expand snipet or jump to filler" })
vim.keymap.set("s", "<c-l>", expand, { expr = true, desc = "expand snipet or jump to filler" })
vim.keymap.set("i", "<tab>", jump_next, { expr = true, desc = "jump to next snippet filler" })
vim.keymap.set("s", "<tab>", jump_next, { expr = true, desc = "jump to next snippet filler" })
vim.keymap.set("i", "<s-tab>", jump_prev, { expr = true, desc = "jump to previous snippet filler" })
vim.keymap.set("s", "<s-tab>", jump_prev, { expr = true, desc = "jump to previous snippet filler" })
