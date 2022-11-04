vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.conceallevel = 0
vim.opt_local.comments = { "nb:>",
    "b:* [ ]", "b:* [x]", "b:*",
    "b:+ [ ]", "b:+ [x]", "b:+",
    "b:- [ ]", "b:- [x]", "b:-",
    "b:1. [ ]", "b:1. [x]", "b:1." }
vim.opt_local.formatoptions:remove({ "c" })
vim.opt_local.formatoptions:append({ j = true, r = true, o = true })

local function get_range(args)
    -- get target range from user command args
    local from = args.line1
    local to = args.line2
    local another = vim.fn.line("v")
    if from == to and from ~= another then
        if another < from then
            from = another
        else
            to = another
        end
    end
    return from, to
end

local LIST_PATTERN = [[\v^\s*([*+-]|\d+\.)\s+]]
local function markdown_checkbox(args)
    local from, to = get_range(args)
    local curpos = vim.fn.getcursorcharpos()
    local lines = vim.fn.getline(from, to)

    for lnum = from, to, 1 do
        local line = lines[lnum - from + 1]

        if not vim.regex(LIST_PATTERN):match_str(line) then
            -- not list -> add list marker and blank box
            vim.fn.setline(lnum, vim.fn.substitute(line, [[\v\S|$]], [[- [ ] \0]], ""))
            if lnum == curpos[1] then
                vim.fn.setcursorcharpos({ curpos[1], curpos[2] + 6 })
            end
        elseif vim.regex(LIST_PATTERN .. [[\[ \]\s+]]):match_str(line) then
            -- blank box -> check
            vim.fn.setline(lnum, vim.fn.substitute(line, "\\[ \\]", "[x]", ""))
        elseif vim.regex(LIST_PATTERN .. [[\[x\]\s+]]):match_str(line) then
            -- checked box -> uncheck
            vim.fn.setline(lnum, vim.fn.substitute(line, "\\[x\\]", "[ ]", ""))
        else
            -- list but no box -> add box after list marker
            vim.fn.setline(lnum, vim.fn.substitute(line, [[\v\S+]], "\\0 [ ]", ""))
            if lnum == curpos[1] then
                vim.fn.setcursorcharpos({ curpos[1], curpos[2] + 4 })
            end
        end
    end
end

vim.api.nvim_buf_create_user_command(0, "MarkdownCheckbox", markdown_checkbox, {
    range = true, force = true, desc = "toggle checkbox in the markdown"
})
vim.keymap.set({ "n", "i", "x" }, "<C-j>", "<cmd>MarkdownCheckbox<cr>", {
    buffer = true, desc = "toggle checkbox in the markdown"
})

local undo = vim.b.undo_ftplugin
if undo == nil then
    undo = ""
else
    undo = undo .. "|"
end
vim.b.undo_ftplugin = undo
    .. "setlocal conceallevel< comments< formatoptions<"
    .. "| delcommand -buffer MarkdownCheckbox"
    .. "| unmap <buffer> <C-j>"
