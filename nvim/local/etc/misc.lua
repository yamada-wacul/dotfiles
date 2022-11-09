-- 細々した挙動を変えるオプション
vim.opt.number = true -- Show the line number
vim.opt.numberwidth = 2
vim.opt.showcmd = true
vim.opt.showtabline = 1
vim.opt.scrolloff = 3 -- Show least &scrolloff lines before/after cursor
vim.opt.sidescrolloff = 3

vim.opt.inccommand = "split"
vim.opt.incsearch = true
vim.opt.grepprg = "rg --vimgrep --no-heading"
vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"

vim.opt.clipboard = "unnamedplus,unnamed"

if vim.fn.executable('win32yank.exe') then
    vim.g.clipboard = {
        name = 'win32yank-wsl',
        copy = {
            ['+'] = 'win32yank.exe -i --crlf',
            ['*'] = 'win32yank.exe -i --crlf',
        },
        paste = {
            ['+'] = 'win32yank.exe -o --lf',
            ['*'] = 'win32yank.exe -o --lf',
        },
        cache_enabled = 0,
    }
end

vim.opt.hidden = true -- Enable to edit without saving

vim.opt.history = 10000

-- カラースキームの適用
vim.cmd([[
    syntax enable
    colorscheme momiji
]])

-- 検索結果ハイライトの消去
vim.keymap.set("n", "<C-l>", "<cmd>nohlsearch<cr><C-l>", {
    desc = "Clear highlighting of the searched words (nohlsearch)"
})

-- Quickfixの表示
vim.keymap.set("n", "<leader>qo", "<cmd>copen<cr><esc>", {
    noremap = true,
    desc = "open a window to show the current list of errors"
})

-- よく間違えるmapを消す
vim.keymap.set("n", "Q", "<nop>", { noremap = true, desc = "nop" })
vim.keymap.set("n", "gQ", "<nop>", { noremap = true, desc = "nop" })

-- ウインドウタイトルをCWDのBasenameにする
vim.opt.title = true
vim.opt.titlestring = "%(%{fnamemodify(getcwd(),':t')}%)"

-- 不要な標準プラグインを無効化
vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_2html_plugin = 1

-- 必要な標準プラグインを有効化
vim.cmd([[
    packadd cfilter
]])
