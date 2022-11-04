local telescope = require("telescope")
local actions = require("telescope.actions")

require("local.with.telescope_style")

-- Setup    =================================================================================
telescope.setup({
    defaults = {
        set_env = { ["COLORTERM"] = "truecolor" },
        layout_strategy = "vertical",
        -- Global remapping
        mappings = {
            i = {
                ["<cr>"] = actions.select_default,
                ["<c-space>"] = actions.toggle_selection,
                ["<esc>"] = actions.close,
            },
            n = {
                ["<c-p>"] = actions.move_selection_previous,
                ["<c-n>"] = actions.move_selection_next,
                ["<esc>"] = actions.close,
                ["<space>"] = actions.toggle_selection,
            },
        },
        shorten_path = false,
    },
    -- Extensions ===============================================================================
    extensions = {
        ---- gogh ====================
        gogh = {
            keys = {
                list = {
                    cd = "default",
                    open = "<c-e>",
                    lcd = nil,
                    tcd = nil,
                },
                repos = {
                    get = "<cr>",
                    browse = "<c-o>",
                },
            },
        },
        ---- frecency ================
        frecency = {
            workspaces = {
                ["conf"] = vim.env.DOTS,
                ["plugin"] = vim.env.XDG_DATA_HOME .. "/nvim/site/pack/packer",
                ["aiadoc"] = vim.env.HOME .. "/Projects/github.com/wcl48/ai-analyst-doc",
                ["aiaocha"] = vim.env.HOME .. "/Projects/github.com/wcl48/ai-analyst-ocha",
                ["aiaback"] = vim.env.HOME .. "/go/src/github.com/wcl48/ai-analyst-back",
            },
        },
    },
})

-- Keymaps =================================================================================
local setmap = function(modes, lhr, rhr, desc)
    vim.keymap.set(modes, lhr, rhr, { noremap = true, silent = true, desc = desc })
end

setmap("n", "<leader>ff", function() require("telescope.builtin").find_files() end, "find files with Telescope")
setmap("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, "find help tags with Telescope")
setmap("n", "<leader>f:", function() require("telescope.builtin").command_history() end, "find help tags with Telescope")
setmap("n", "<leader>fgs", function() require("telescope.builtin").git_status() end,
    "find files from git-status with Telescope")
setmap("n", "<leader>fgc", function() require("telescope.builtin").git_commits() end, "find commits with Telescope")
setmap("n", "<leader>flr", function() require("telescope.builtin").lsp_references() end,
    "find references from LSP with Telescope")
setmap("n", "<leader>fld", function() require("telescope.builtin").lsp_document_symbols() end,
    "find document symbols from LSP with Telescope")
setmap("n", "<leader>flw", function() require("telescope.builtin").lsp_workspace_symbols() end,
    "find workspace symbols from LSP with Telescope")
setmap("n", "<leader>fla", function() require("telescope.builtin").lsp_code_actions() end,
    "find code actions from LSP with Telescope")
setmap("v", "<leader>fla", "<cmd>Telescope lsp_range_code_actions<cr>",
    "find code actions for the selection from LSP with Telescope")

-- NOTE: telescope.extensions.xxx へのアクセス (keymap.setで使ったり) をすると、
-- 自動でload_extensionsされて、extensionのsetupがデフォ値（つまり空）で呼ばれてしまうので、
-- 先に telescope.setup({extensions={[xxx]={}}}) を呼んでおかないといけない。
setmap("n", "<leader>fw", function() telescope.extensions.windows.windows() end,
    "find a window and focus it with Telescope")
setmap("n", "<leader>fgi", function() telescope.extensions.gh.issues() end, "find an issue from GitHub with Telescope")
setmap("n", "<leader>fgp", function() telescope.extensions.gh.pull_request() end,
    "find a pull-request from GitHub with Telescope")
setmap("n", "<leader>fp", function() telescope.extensions.gogh.list() end,
    "find a project from Gogh with Telescope")
setmap("n", "<leader>fpl", function() telescope.extensions.gogh.list() end,
    "find a project from Gogh with Telescope")
setmap("n", "<leader>fpr", function() telescope.extensions.gogh.repos() end,
    "find a repository from GitHub with Telescope and Gogh")
setmap("n", "<leader>fac", function() require("local.with.telescope_pickers").angular_files("component")() end,
    "find an angular component file with Telescope")
setmap("n", "<leader>fas", function() require("local.with.telescope_pickers").angular_files("service")() end,
    "find an angular service file with Telescope")
setmap("n", "<leader>fam", function() require("local.with.telescope_pickers").angular_files("module")() end,
    "find an angular module file with Telescope")
setmap("n", "<leader><leader>c", function() require("local.with.telescope_pickers").config() end,
    "find a configuration file with Telescope")
setmap("n", "<leader><leader>p", function() require("local.with.telescope_pickers").packer() end,
    "find a plugin with Telescope")
setmap("n", "<leader>fgr", function() require("local.with.telescope_pickers").git_recent() end,
    "find a file that has difference in recent commits with Telescope")
setmap("n", "<leader>fmw", function() require("local.with.telescope_pickers").recent_written_files() end,
    "find a file that has written recently with Telescope")
setmap("n", "<leader>fmr", function() require("local.with.telescope_pickers").recent_used_files() end,
    "find a file that has loaded recently with Telescope")
setmap("n", "<leader>fmu", function() require("local.with.telescope_pickers").recent_used_files() end,
    "find a file that has loaded recently with Telescope")
setmap("n", "<leader>fb", function() require("local.with.telescope_pickers").buffers() end,
    "find a buffer with Telescope")
setmap("n", "<leader>fgb", function() require("local.with.telescope_pickers").git_branches() end,
    "find a git-branch with Telescope")
