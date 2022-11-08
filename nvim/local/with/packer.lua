local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.cmd("packadd packer.nvim")

local packer = require("packer")

-- auto compile ===================================================================

local function compile(file)
    file = vim.fn.fnamemodify(file, ":p")
    if not (string.match(file, "/local/with/")) then
        return
    end
    vim.cmd("luafile " .. file)
    vim.cmd("luafile " .. vim.fn.stdpath("config") .. "/local/with/packer.lua")
    vim.cmd("PackerCompile")
end

vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("local-with-packer-compile", {}),
    pattern = "*.lua",
    callback = function(e)
        compile(e.file)
    end,
})

-- update (with shell) =============================================================

local function update_all()
    packer.sync()
    vim.defer_fn(function()
        require("local.mod.volaterm").split(0, "topleft", {
            exec = vim.o.shell .. ' -c "source ' .. vim.env.ZDOTDIR .. '/.zshrc && update"',
        })
    end, 5000)
end

vim.api.nvim_create_user_command("UpdateAll", update_all, { force = true })

-- startup =========================================================================

local packer_option = {}
if vim.fn.has("mac") then
    packer_option["max_jobs"] = 60
end
packer.init(packer_option)
packer.startup(function(use)
    use({ "wbthomason/packer.nvim", opt = true })

    -- Libraries              ======================================================

    use({
        "nvim-lua/plenary.nvim",
        "nvim-lua/popup.nvim",
        "kyazdani42/nvim-web-devicons",
        "vim-denops/denops.vim",
    })

    use({
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "css",
                    "dockerfile",
                    "go",
                    "gomod",
                    "gowork",
                    "graphql",
                    "help",
                    "html",
                    "http",
                    "javascript",
                    "jsdoc",
                    "json",
                    "json5",
                    "jsonc",
                    "lua",
                    "make",
                    "perl",
                    "python",
                    "regex",
                    "rust",
                    "scss",
                    "todotxt",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "vue",
                    "yaml",
                },
                sync_install = false,

                highlight = {
                    -- `false` will disable the whole extension
                    enable = false,
                },
            })
        end,
    })
    use({
        "kyoh86/backgroundfile.nvim",
        "kyoh86/climbdir.nvim",
    })

    -- Visuals                 ==================================================

    local momiji = vim.env.XDG_CONFIG_HOME .. "/momiji"
    use(momiji)

    use("lambdalisue/readablefold.vim")
    use("rbtnn/vim-ambiwidth")
    use({
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require('treesitter-context').setup({
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            })
        end,
    })
    use({
        "petertriho/nvim-scrollbar",
        config = function()
            require("scrollbar.handlers.search").setup()
            require("scrollbar").setup({
                marks = {
                    Search = {
                        color = vim.g.momiji_colors.lightblue,
                        highlight = "IncSearch",
                    },
                },
                handlers = {
                    search = true,
                },
            })
        end,
    })

    -- Status                  ==================================================

    use({
        "feline-nvim/feline.nvim",
        config = function()
            require("local.with.feline")
        end,
        requires = { "lewis6991/gitsigns.nvim", "kyazdani42/nvim-web-devicons", momiji },
    })

    use({
        "kyoh86/vim-cinfo",
        config = function()
            vim.keymap.set("n", "<leader>ic", "<plug>(cinfo-show-cursor)", {
                desc = "show informations about the current cursor"
            })
            vim.keymap.set("n", "<leader>ib", "<plug>(cinfo-show-buffer)", {
                desc = "show informations about the current buffer"
            })
            vim.keymap.set("n", "<leader>ih", "<plug>(cinfo-show-highlight)", {
                desc = "show informations about the highlight on the current cursor"
            })
        end,
    })

    -- Fuzzy finder            ==================================================

    use({
        {
            "nvim-telescope/telescope.nvim",
            requires = {
                { "nvim-lua/popup.nvim" },
                { "nvim-lua/plenary.nvim" },
                { "lambdalisue/mr.vim" },
            },
            config = function()
                require("local.with.telescope")
            end,
        },
        "kyoh86/telescope-windows.nvim",
        "nvim-telescope/telescope-github.nvim",
        "kyoh86/telescope-gogh.nvim",
        {
            "kyoh86/telescope-zenn.nvim",
            requires = { "kyoh86/vim-zenn-autocmd" },
        },
        {
            "nvim-telescope/telescope-frecency.nvim",
            requires = { "tami5/sql.nvim" },
        },
    })

    -- LSP                     ==================================================

    use({
        -- show progress of lsp-server
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({})
        end,
    })

    use({
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "b0o/schemastore.nvim",
        {
            "neovim/nvim-lspconfig",
            config = function()
                require("local.with.lsp")
            end,
        },
        {
            "kosayoda/nvim-lightbulb",
            config = function()
                -- Showing defaults
                local lightbulb = require("nvim-lightbulb")
                lightbulb.update_lightbulb({
                    -- LSP client names to ignore
                    -- Example: {"sumneko_lua", "null-ls"}
                    ignore = {},
                    sign = {
                        enabled = true,
                        -- Priority of the gutter sign
                        priority = 10,
                    },
                })
                local group = vim.api.nvim_create_augroup("local-with-lightbulb", { clear = true })
                vim.api.nvim_create_autocmd(
                    { "CursorHold", "CursorHoldI" },
                    { group = group, callback = lightbulb.update_lightbulb }
                )
            end,
        },
    })
    use({
        "lukas-reineke/lsp-format.nvim",
        config = function()
            require("lsp-format").setup({})
        end
    })

    -- Completion & Snippet    ==================================================

    use({
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
        {
            "hrsh7th/nvim-cmp",
            config = function()
                require("local.with.completion")
            end,
        },
        {
            "golang/vscode-go",
            opt = true,
            ft = { "go" },
        },
    })

    -- Text handlers           ==================================================

    use({
        "junegunn/vim-easy-align",
        config = function()
            -- Start interactive EasyAlign in visual mode (e.g. vipga)
            vim.keymap.set({ "x", "n" }, "ga", "<plug>(EasyAlign)", {
                desc = "EasyAlign"
            })
        end,
    })

    use({
        "arthurxavierx/vim-caser",
        "kana/vim-textobj-user",
        "kana/vim-textobj-line",
        "kana/vim-textobj-entire",
        "sgur/vim-textobj-parameter",
        "whatyouhide/vim-textobj-xmlattr",
        {
            "machakann/vim-textobj-functioncall",
            config = function()
                vim.g.textobj_generics = {
                    {
                        ["header"] = "\\<\\%(\\h\\k*\\.\\)*\\h\\k*",
                        ["bra"] = "<",
                        ["ket"] = ">",
                        ["footer"] = "",
                    },
                }
                -- Genericsのカッコ（<>）絡み
                vim.keymap.set({ "x", "o" }, "iG", '<cmd>call textobj#functioncall#ip("o", g:textobj_generics)<cr>', {
                    desc = "a textobj in the brackets for the generics (<>)"
                })
                vim.keymap.set({ "x", "o" }, "aG", '<cmd>call textobj#functioncall#i("o", g:textobj_generics)<cr>', {
                    desc = "a textobj around the brackets for the generics (<>)"
                })
                -- Functionの呼び出し絡み
                vim.keymap.set({ "x", "o" }, "iF", "<plug>(textobj-functioncall-innerparen-i)", {
                    desc = "a textobj in the function calling"
                })
                vim.keymap.set({ "x", "o" }, "aF", "<plug>(textobj-functioncall-a)", {
                    desc = "a textobj around the function calling"
                })
            end,
        },
    })

    use({
        {
            "kana/vim-operator-replace",
            config = function()
                vim.keymap.set('', '_', '<Plug>(operator-replace)', {})
            end,
            requires = { "kana/vim-operator-user" },
        },
        {
            "osyo-manga/vim-operator-jump_side",
            requires = { "kana/vim-operator-user" },
            config = function()
                -- textobj の先頭へ移動する
                vim.keymap.set("n", "[<leader>", "<plug>(operator-jump-head)", {
                    desc = "jumps to head of the textobj"
                })
                -- textobj の末尾へ移動する
                vim.keymap.set("n", "]<leader>", "<plug>(operator-jump-tail)", {
                    desc = "jumps to tail of the textobj"
                })
            end,
        },
    })

    use({
        "machakann/vim-sandwich",
        config = function()
            -- ignore s instead of the cl
            vim.keymap.set("n", "s", "<nop>", { noremap = true, desc = "nop" })
            vim.keymap.set("x", "s", "<nop>", { noremap = true, desc = "nop" })

            vim.keymap.set(
                "n",
                "sc",
                "<plug>(operator-sandwich-replace)<plug>(operator-sandwich-release-count)<plug>(textobj-sandwich-query-a)"
                ,
                { silent = true, desc = "replace sandwich" }
            )
            vim.keymap.set(
                "n",
                "scb",
                "<plug>(operator-sandwich-replace)<plug>(operator-sandwich-release-count)<plug>(textobj-sandwich-auto-a)"
                ,
                { silent = true, desc = "replace sandwich for the typical brackets" }
            )
        end,
    })

    use({
        "machakann/vim-swap",
        config = function()
            vim.keymap.set("o", "i,", "<plug>(swap-textobject-i)", { desc = "a testobj in the parameter" })
            vim.keymap.set("x", "i,", "<plug>(swap-textobject-i)", { desc = "a testobj in the parameter" })
            vim.keymap.set("o", "a,", "<plug>(swap-textobject-a)", { desc = "a testobj around the parameter" })
            vim.keymap.set("x", "a,", "<plug>(swap-textobject-a)", { desc = "a testobj around the parameter" })
        end,
    })

    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            vim.cmd([[highlight! link IndentBlanklineChar MomijiGrayscale1]])
            require("indent_blankline").setup({
                show_first_indent_level = false,
                buftype_exclude = { "terminal", "nofile" },
            })
        end,
    })

    -- Enhance registers       ==================================================

    use({
        "tversteeg/registers.nvim",
        config = function()
            local registers = require("registers")
            registers.setup({
                bind_keys = {
                    insert = false
                },
                window = {
                    border = "solid"
                }
            })
            vim.cmd([[
                imap <buffer> <expr> <C-R> &ft=='TelescopePrompt' ? '<C-R>' : registers#peek('<C-R>')
                highlight link RegistersPrefixYank Constant
                highlight link RegistersPrefixHistory Constant
                highlight link RegistersPrefixSelection Constant
                highlight link RegistersPrefixDefault Constant
                highlight link RegistersPrefixUnnamed Constant
                highlight link RegistersPrefixReadOnly Constant
                highlight link RegistersPrefixLastSearch Constant
                highlight link RegistersPrefixNamed Constant
                highlight link RegistersPrefixDelete Constant
            ]])
        end,
    })

    use({
        "bfredl/nvim-miniyank",
        setup = function()
            vim.keymap.set("", "p", "<plug>(miniyank-autoput)", { desc = "autoput with miniyank" })
            vim.keymap.set("", "P", "<plug>(miniyank-autoPut)", { desc = "autoput with miniyank" })
        end,
    })

    -- Search & Replace        ==================================================

    use({
        "kyoh86/vim-ripgrep",
        -- "jremmen/vim-ripgrep",
        cmd = "Ripgrep",
        setup = function()
            vim.cmd([[ cabbrev <expr> Rg (getcmdtype() ==# ":" && getcmdline() ==# "Rg") ? "Ripgrep" : "Rg" ]])
        end,
        config = function()
            vim.api.nvim_create_user_command(
                "Ripgrep",
                "call ripgrep#search(<q-args>)",
                { nargs = "*", complete = "file" }
            )
        end,
    })

    use({ "kevinhwang91/nvim-hlslens",
        config = function()
            require('hlslens').setup()

            local kopts = { noremap = true, silent = true }

            vim.api.nvim_set_keymap('n', 'n',
                [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', 'N',
                [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.keymap.set("n", "<C-l>", "<cmd>nohlsearch<cr><cmd>lua require('hlslens').stop()<cr><C-l>", {
                noremap = true,
                desc = "Clear highlighting of the searched words (nohlsearch) with hlslens flow window"
            })

        end
    })

    use({
        "thinca/vim-qfreplace",
        cmd = "Qfreplace",
        setup = function()
            local group = vim.api.nvim_create_augroup("local-with-qfreplace-keymap", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "qf",
                group = group,
                callback = function()
                    vim.keymap.set("n", "<leader>r", "<cmd>Qfreplace<cr>", {
                        noremap = true,
                        buffer = true,
                        nowait = true,
                        silent = true,
                        desc = "replace with quickfix"
                    })
                end,
            })
        end,
    })

    -- Execution               ==================================================

    use({
        "thinca/vim-quickrun",
        config = function()
            vim.g.quickrun_no_default_key_mappings = 1
            vim.keymap.set("n", "<leader>x", "<plug>(quickrun)", { desc = "execute the current buffer with quickrun" })
            vim.keymap.set("v", "<leader>x", "<plug>(quickrun)", { desc = "execute the current buffer with quickrun" })
            require("local.with.quickrun")
        end,
    })

    use({
        "vim-test/vim-test",
        requires = { "tpope/vim-dispatch" },
        cmd = {
            "TestVisit",
            "TestNearest",
            "TestNearest",
            "TestFile",
            "TestSuite",
            "TestLast",
        },
        config = function()
            vim.g["test#strategy"] = "neovim"
            vim.g["test#neovim#term_position"] = "aboveleft"
            vim.g["test#neovim#start_normal"] = 1
            vim.g["test#preserve_screen"] = 1
            vim.g["test#echo_command"] = true
            vim.g["test#lua#busted#executable"] = "vusted"
        end,
        setup = function()
            vim.keymap.set("n", "<leader>tg", "<cmd>TestVisit<cr>", {
                silent = true, noremap = true, desc = "open the last run test in the current buffer"
            })
            vim.keymap.set("n", "<leader>tt", "<cmd>TestNearest<cr>", {
                silent = true, noremap = true,
                desc = "run a test nearest to the cursor (some test runners may not support this)"
            })
            vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest<cr>", {
                silent = true, noremap = true,
                desc = "run a test nearest to the cursor (some test runners may not support this)"
            })
            vim.keymap.set("n", "<leader>tf", "<cmd>TestFile<cr>", {
                silent = true, noremap = true,
                desc = "run tests for the current file",
            })
            vim.keymap.set("n", "<leader>ta", "<cmd>TestSuite<cr>", {
                silent = true, noremap = true,
                desc = "run test suite of the current file",
            })
            vim.keymap.set("n", "<leader>tl", "<cmd>TestLast<cr>", {
                silent = true, noremap = true,
                desc = "run the last test",
            })
        end,
    })

    -- Git & GitHub            ==================================================

    use({
        "iberianpig/tig-explorer.vim",
        cmd = "Tig",
        setup = function()
            vim.keymap.set("n", "<leader>gt", "<cmd>Tig<cr>", { noremap = true, desc = "open the tig window" })
        end,
    })

    use({
        "tyru/open-browser.vim",
        config = function()
            vim.cmd("packadd open-browser.vim")
        end,
    })

    use({
        "tyru/open-browser-github.vim",
        requires = { "tyru/open-browser.vim" },
        after = "open-browser.vim",
        cmd = {
            "OpenGithubFile",
            "OpenGithubIssue",
            "OpenGithubPullReq",
            "OpenGithubProject",
            "OpenGithubCommit",
        },
    })

    use({
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            local gitsigns = require("gitsigns")
            gitsigns.setup({
                on_attach = function(bufnr)
                    vim.keymap.set("n", "]g", gitsigns.next_hunk,
                        { buffer = bufnr, noremap = true, desc = "jump to next git-diff hunk" })
                    vim.keymap.set("n", "[g", gitsigns.prev_hunk,
                        { buffer = bufnr, noremap = true, desc = "jump to previous git-diff hunk" })
                end,
            })
        end,
    })

    use({
        "kyoh86/gitstat.nvim",
        config = function()
            local C = vim.g.momiji_colors
            local stat = require("gitstat")
            stat.setup({
                style = {
                    window = { bg = C.green, fg = C.black },
                    branch = { bg = C.green, fg = C.black },
                    remote = { bg = C.green, fg = C.black },
                    ahead = { bg = C.yellow, fg = C.black },
                    behind = { bg = C.yellow, fg = C.black },
                    recruit = { bg = C.yellow, fg = C.black },
                    unmerged = { bg = C.yellow, fg = C.black },
                    staged = { bg = C.yellow, fg = C.black },
                    unstaged = { bg = C.yellow, fg = C.black },
                    untracked = { bg = C.yellow, fg = C.black },
                },
            })
            stat.show()
        end,
    })

    -- Buf/win manipulation    ==================================================

    use({
        "kyoh86/vim-quotem",
        config = function()
            vim.keymap.set("v", "<leader>yb", "<plug>(quotem-named)", {
                desc = "copy markdown-quoted text from selection with buffer name"
            })
            vim.keymap.set("v", "<leader>Yb", "<plug>(quotem-fullnamed)", {
                desc = "copy markdown-quoted text from selection with full-name"
            })
            vim.keymap.set("n", "<leader>yb", "<plug>(operator-quotem-named)", {
                desc = "start to copy markdown-quoted text with buffer name"
            })
            vim.keymap.set("n", "<leader>Yb", "<plug>(operator-quotem-fullnamed)", {
                desc = "start to copy markdown-quoted text with full-name"
            })
        end,
    })

    use({
        "kyoh86/vim-copy-buffer-name",
        config = function()
            vim.keymap.set("n", "<leader>y%", "<plug>(copy-buffer-name)", { silent = true, desc = "copy bufer name" })
            vim.keymap.set("n", "<leader>Y%", "<plug>(copy-buffer-full-name)", { silent = true, desc = "copy full-name" })
        end,
    })

    use({
        "kyoh86/wipeout-buffers.nvim",
        config = function()
            local keep = function()
                require("wipeout").menu({ keep_layout = true })
            end
            vim.keymap.set("n", "<C-q>", function()
                require("wipeout").menu()
            end, { noremap = true, silent = true, desc = "show the menu to wipeout buffers" })
            vim.keymap.set("n", "<A-q>", keep,
                { noremap = true, silent = true, desc = "show the menu to wipeout buffers without closing windcow" })
            vim.keymap.set("n", "<C-S-q>", keep,
                { noremap = true, silent = true, desc = "show the menu to wipeout buffers without closing windcow" })
        end,
    })

    use({
        "t9md/vim-choosewin",
        config = function()
            vim.keymap.set("n", "<leader>wf", "<plug>(choosewin)", { desc = "focus to another window" })
        end,
    })

    use({
        "kyoh86/curtain.nvim",
        config = function()
            vim.keymap.set("n", "<leader>wr", "<plug>(curtain-start)", { desc = "resize current window" })
        end,
    })

    -- Others                  ==================================================

    use({
        "chentoast/marks.nvim",
        config = function()
            require("marks").setup({
                -- whether to map keybinds or not. default true
                default_mappings = true,
                cyclic = true,
            })
        end,
    })

    use({
        -- Enhance $EDITOR behavior in terminal
        "lambdalisue/guise.vim",
    })

    use({
        "lambdalisue/fern.vim",
        requires = {
            { "lambdalisue/fern-git-status.vim" },
            { "lambdalisue/fern-hijack.vim" },
        },
        setup = function()
            vim.g["fern#disable_default_mappings"] = 1
        end,
        config = function()
            vim.cmd("runtime! local/with/fern.vim")
        end,
    })

    use({ "tyru/capture.vim", cmd = "Capture" })

    -- Languages & Integration ==================================================

    -- zenn.dev

    use({
        {
            "kyoh86/vim-zenn-autocmd",
            config = function()
                vim.fn["zenn_autocmd#enable"]()
                local group = vim.api.nvim_create_augroup("local-with-zenn-autocmd", { clear = true })
                vim.api.nvim_create_autocmd("User", {
                    pattern = "ZennEnter",
                    group = group,
                    callback = function()
                        vim.keymap.set("n", "<leader>zna", "<cmd>ZennNewArticle<cr>", {
                            noremap = true, silent = true,
                            desc = "create new aricle for the zenn.com",
                        })
                        vim.keymap.set("n", "<leader>zfa", "<cmd>Telescope zenn articles<cr>", {
                            noremap = true, silent = true,
                            desc = "select an aricle for the zenn.com",

                        })
                        vim.keymap.set("n", "<leader>fza", "<cmd>Telescope zenn articles<cr>", {
                            noremap = true, silent = true,
                            desc = "select an aricle for the zenn.com",

                        })
                        vim.cmd("PackerLoad zenn-vim")
                    end,
                })
                vim.api.nvim_create_autocmd("User", {
                    pattern = "ZennLeave",
                    group = group,
                    callback = function()
                        pcall(vim.keymap.del, "n", "<leader>zna")
                        pcall(vim.keymap.del, "n", "<leader>zfa")
                        pcall(vim.keymap.del, "n", "<leader>fza")
                    end,
                })
            end,
        },
        {
            "kkiyama117/zenn-vim",
            requires = { "kyoh86/vim-zenn-autocmd" },
            config = function()
                vim.g["zenn#article#edit_new_cmd"] = "edit"
                vim.cmd([[
                    command! -nargs=0 ZennUpdate call zenn#update()
                    command! -nargs=* ZennPreview call zenn#preview(<f-args>)
                    command! -nargs=0 ZennStopPreview call zenn#stop_preview()
                    command! -nargs=* ZennNewArticle call zenn#new_article(<f-args>)
                    command! -nargs=* ZennNewBook call zenn#new_book(<f-args>)
                ]])
            end,
        },
    })

    -- Generate annotation comment
    use({
        "danymat/neogen",
        config = function()
            require("neogen").setup({
                enabled = true,
                languages = {
                    lua = {
                        template = {
                            annotation_convention = "emmylua",
                        },
                    },
                },
            })
            vim.keymap.set("n", "<leader>nf", function()
                require("neogen").generate({})
            end, { noremap = true, silent = true, desc = "genarate annotation comment" })
        end,
    })

    -- - REST client
    use({
        "rest-nvim/rest.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        ft = "rest",
        config = function()
            require("local.with.rest")
        end,
    })

    -- - jq
    use("bfrg/vim-jq")

    -- - jsonl
    use("kyoh86/vim-jsonl")

    -- - json
    use({
        "mogelbrod/vim-jsonpath",
        config = function()
            -- Define mappings for json buffers
            local group = vim.api.nvim_create_augroup("local-with-jsonpath", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "json",
                group = group,
                callback = function(t)
                    vim.keymap.set("n", "<leader>d", vim.fn["jsonpath#echo"], {
                        buffer = t['buf'], desc = "echo json-path under the cursor"
                    })
                    vim.keymap.set("n", "<leader>g", vim.fn["jsonpath#goto"], {
                        buffer = t['buf'], desc = "searches the given json-path, goto it if found"
                    })
                end,
            })
        end,
        ft = "json",
    })

    -- - go
    use({
        {
            "kyoh86/vim-go-filetype",
            setup = function()
                vim.g.go_mod_filetype = "always"
            end,
        },
        "kyoh86/vim-go-scaffold",
        { "kyoh86/vim-go-testfile", ft = "go" },
        { "kyoh86/vim-go-coverage", ft = "go" },
    })

    -- - markdown
    use({
        {
            "iamcco/markdown-preview.nvim",
            setup = function()
                vim.g.mkdp_port = 8080
                vim.g.mkdp_refresh_slow = 1
                vim.g.mkdp_echo_preview_url = 1
                vim.g.mkdp_theme = "light"
            end,
            run = "cd app && yarn install",
            ft = "markdown",
        },
        { "dhruvasagar/vim-table-mode", ft = "markdown" },
        {
            "kyoh86/markdown-image.nvim",
            ft = "markdown",
            config = function()
                local mdimg = require("markdown-image")
                local gyazo = require("markdown-image.gyazo")
                vim.keymap.set("n", "<leader>mir", function()
                    mdimg.replace(gyazo.new(vim.g.my_gyazo_token))
                end, { noremap = true, desc = "upload the image to Gyazo and replace the url for it" })
                vim.keymap.set("n", "<leader>mip", function()
                    mdimg.put(gyazo.new(vim.g.my_gyazo_token))
                end, { noremap = true, desc = "upload the image from clipboard to Gyazo and put the image" })
            end,
        },
    })

    -- - others
    use("rust-lang/rust.vim")
    use("jparise/vim-graphql")
    use({ "lambdalisue/vim-backslash", ft = "vim" })
    use("glench/vim-jinja2-syntax")
    use("briancollins/vim-jst")
    use({ "cespare/vim-toml", branch = "main" })
    use("leafgarland/typescript-vim")
    use({
        "terrortylor/nvim-comment",
        config = function()
            require('nvim_comment').setup()
        end,
    })
    -- use({
    --     "mhartington/formatter.nvim",
    --     config = function()
    --         require("local.with.formatter")
    --     end,
    -- })
    use("pangloss/vim-javascript")
    use("delphinus/vim-firestore")

    use({ "vim-jp/autofmt", ft = "help" })

    use({ "hashivim/vim-terraform", ft = "terraform" })

    -- Plugin Development      ==================================================
    use("folke/neodev.nvim")
    use({ "prabirshrestha/async.vim", cmd = "AsyncEmbed" })
    use({ "vim-jp/vital.vim", cmd = "Vitalize" })
    use({ "lambdalisue/vital-Whisky", cmd = "Vitalize" })
    use({
        "thinca/vim-themis",
        config = function()
            local path = _G["packer_plugins"]["vim-themis"].path
            vim.env.PATH = vim.env.PATH .. ":" .. path .. "/bin"
        end,
    })
end)

-- vim: foldmethod=syntax
