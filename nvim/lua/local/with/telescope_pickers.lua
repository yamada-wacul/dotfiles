local pickers = require("telescope.pickers")
local builtin = require("telescope.builtin")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local utils = require("telescope.utils")
local conf = require("telescope.config").values
local actions = require("telescope.actions")

-- Pickers ==================================================================================
local my_pickers = {}

my_pickers.git_recent = function(o)
    local opts = o or {}
    local depth = utils.get_default(opts.depth, 5)

    if opts.cwd then
        opts.cwd = vim.fn.expand(opts.cwd)
    end

    opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

    pickers.new(opts, {
        prompt_title = "Git Recent",
        finder = finders.new_oneshot_job({ "git", "diff", "--name-only", depth and "HEAD~" .. depth or "HEAD" }, opts),
        previewer = conf.file_previewer(opts),
        sorter = conf.file_sorter(opts),
    }):find()
end

my_pickers.recent_written_files = function(o)
    local opts = o or {}
    local entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)
    pickers.new(opts, {
        prompt_title = "Recent written files",
        finder = finders.new_table({
            results = vim.fn["mr#mrw#list"](),
            entry_maker = entry_maker,
        }),
        previewer = conf.file_previewer(opts),
        sorter = conf.file_sorter(opts),
    }):find()
end

my_pickers.recent_used_files = function(o)
    local opts = o or {}
    local entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)
    pickers.new(opts, {
        prompt_title = "Recent used files",
        finder = finders.new_table({
            results = vim.fn["mr#mru#list"](),
            entry_maker = entry_maker,
        }),
        previewer = conf.file_previewer(opts),
        sorter = conf.file_sorter(opts),
    }):find()
end

my_pickers.angular_files = function(filetype)
    return function()
        builtin.find_files({ find_command = { "rg", "--files", "--glob", "*." .. filetype .. ".*" } })
    end
end

my_pickers.git_branches = function(opts)
    opts = opts or {}
    opts.attach_mappings = function(_, map)
        actions.select_default:replace(actions.git_switch_branch)
        map("i", "<c-x>", actions.git_checkout)
        map("n", "<c-x>", actions.git_checkout)

        map("i", "<c-t>", actions.git_track_branch)
        map("n", "<c-t>", actions.git_track_branch)

        map("i", "<c-r>", actions.git_rebase_branch)
        map("n", "<c-r>", actions.git_rebase_branch)

        map("i", "<c-a>", actions.git_create_branch)
        map("n", "<c-a>", actions.git_create_branch)

        map("i", "<c-d>", actions.git_delete_branch)
        map("n", "<c-d>", actions.git_delete_branch)
        return true
    end
    require("telescope.builtin").git_branches(opts)
end

my_pickers.buffers = function(opts)
    local action_state = require("telescope.actions.state")
    opts = opts or {}
    -- opts.previewer = false
    -- opts.sort_lastused = true
    -- opts.show_all_buffers = true
    -- opts.shorten_path = false
    opts.attach_mappings = function(prompt_bufnr, map)
        local delete_buf = function()
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            local multi_selections = current_picker:get_multi_selection()

            if next(multi_selections) == nil then
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.api.nvim_buf_delete(selection.bufnr, { force = true })
            else
                actions.close(prompt_bufnr)
                for _, selection in ipairs(multi_selections) do
                    vim.api.nvim_buf_delete(selection.bufnr, { force = true })
                end
            end
        end
        map("i", "<c-d>", delete_buf)
        map("n", "<c-d>", delete_buf)
        return true
    end
    builtin.buffers(opts)
end

my_pickers.packer = function()
    local action_state = require("telescope.actions.state")
    local packerdir = vim.fn.expand("~/.local/share/nvim/site/pack/packer")
    opts = opts or {}
    opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)
    opts.cwd = packerdir
    opts.attach_mappings = function(prompt_bufnr, map)
        local cd = function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            vim.cmd("cd " .. selection[1])
            vim.notify("chdir to " .. selection[1], vim.log.levels.INFO)
        end

        local open_finder = function()
            local selection = action_state.get_selected_entry()
            actions._close(prompt_bufnr, true)
            builtin.find_files({ cwd = selection.path })
        end

        actions.select_default:replace(cd)
        map("i", "<c-f>", open_finder)
        map("n", "<c-f>", open_finder)
        return true
    end

    local findcommand = {
        "find",
        packerdir,
        "-maxdepth",
        2,
        "-mindepth",
        2,
        "-type",
        "d",
        "-wholename",
        packerdir .. "/opt/*",
        "-o",
        "-wholename",
        packerdir .. "/start/*",
    }

    pickers.new(opts, {
        prompt_title = "Find Packer Projects",
        finder = finders.new_oneshot_job(findcommand, opts),
        sorter = conf.file_sorter(opts),
    }):find()
end
my_pickers.config = function()
    builtin.git_files({ cwd = "~/.config" })
end

return my_pickers
