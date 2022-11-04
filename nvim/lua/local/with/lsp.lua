-- ====== attach              ============================================================

local function on_attach(client, bufnr) -- function(client, bufnr)
    require("lsp-format").on_attach(client)
    local setmap = function(modes, lhr, rhr, desc)
        vim.keymap.set(modes, lhr, rhr, { noremap = true, silent = true, buffer = bufnr, desc = desc })
    end
    -- show / edit actions
    setmap("n", "<leader>lh", vim.lsp.buf.hover,
        "displays hover information about the symbol under the cursor in a floating window")
    setmap("n", "<leader>lD", vim.lsp.buf.declaration, "jumps to the declaration of the symbol under the cursor")
    setmap("n", "<leader>ld", vim.lsp.buf.definition, "jumps to the definition of the symbol under the cursor")
    setmap("n", "<leader>li", vim.lsp.buf.implementation,
        "lists all the implementations for the symbol under the cursor in the quickfix window")
    setmap("n", "<leader>lr", vim.lsp.buf.rename, "renames all references to the symbol under the cursor")
    setmap("n", "]l", vim.diagnostic.goto_next, "move to the next diagnostic")
    setmap("n", "[l", vim.diagnostic.goto_prev, "move to the previous diagnostic in the current buffer")
    setmap("n", "<leader>ls", vim.lsp.buf.signature_help,
        "displays signature information about the symbol under the cursor in a floating window")
    setmap({ "n", "v" }, "<leader>lca", vim.lsp.buf.code_action,
        "selects a code action available at the current cursor position")

    -- listup actions
    setmap("n", "<leader>llr", vim.lsp.buf.references,
        "lists all the references to the symbol under the cursor in the quickfix window")
    setmap("n", "<leader>lls", vim.lsp.buf.document_symbol,
        "lists all symbols in the current buffer in the quickfix window")
    setmap("n", "<leader>llS", vim.lsp.buf.workspace_symbol,
        "lists all symbols in the current workspace in the quickfix window")
    setmap("n", "<leader>llc", vim.lsp.buf.incoming_calls,
        "lists all the call sites of the symbol under the cursor in the quickfix window")
    setmap("n", "<leader>llC", vim.lsp.buf.outgoing_calls,
        "lists all the items that are called by the symbol under the cursor in the quickfix window")
    setmap("n", "<leader>lld", vim.diagnostic.setqflist, "add all diagnostics to the quickfix list")

    -- show diagnostics
    setmap("n", "<leader>lll", function()
        vim.diagnostic.open_float({ scope = "cursor" })
    end, "show diagnostics in a floating window")

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true, bold = true })
        vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
        vim.api.nvim_set_hl(0, "LspReferenceWrite", { reverse = true })
        local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
        vim.api.nvim_create_autocmd(
            "CursorHold",
            { group = group, buffer = bufnr, callback = vim.lsp.buf.document_highlight }
        )
        vim.api.nvim_create_autocmd(
            "CursorHoldI",
            { group = group, buffer = bufnr, callback = vim.lsp.buf.document_highlight }
        )
        vim.api.nvim_create_autocmd(
            "CursorMoved",
            { group = group, buffer = bufnr, callback = vim.lsp.buf.clear_references }
        )
    end

    local organizeImport = function() end
    local actions = vim.tbl_get(client.server_capabilities, 'codeActionProvider', "codeActionKinds")
    if actions ~= nil and vim.tbl_contains(actions, "source.organizeImports") then
        organizeImport = function()
            vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
        end
    elseif client.name == "pyright" then
        local params = {
            command = 'pyright.organizeimports',
            arguments = { vim.uri_from_bufnr(0) },
        }
        vim.lsp.buf.execute_command(params)
    end
    local group = vim.api.nvim_create_augroup("lsp_document_format", { clear = true })
    vim.api.nvim_create_autocmd(
        "BufWritePre",
        { group = group, buffer = bufnr, callback = function()
            organizeImport()
            require("lsp-format").format({ fargs = { "sync" } })
        end }
    )
end

-- ====== snippet             ============================================================

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- ====== installer           ============================================================

require("mason").setup({})

-- ====== setup servers       ============================================================

local lsp_list = {}
local function setup(lsp, config)
    config.capabilities = capabilities
    config.on_attach = on_attach
    table.insert(lsp_list, lsp)
    require("lspconfig")[lsp].setup(config)
end

setup("angularls", {})
setup("ansiblels", {})
setup("bashls", {})
setup("cssls", {})
setup("cssmodules_ls", {})
setup("dockerls", {})
setup("golangci_lint_ls", {
    init_options = {
        command = { "golangci-lint", "run", "--enable", "exportloopref", "--out-format", "json", "--issues-exit-code=1" }
    },
})
setup("gopls", {
    init_options = {
        usePlaceholders = true,
        semanticTokens = true,
        staticcheck = true,
        experimentalPostfixCompletions = true,
        directoryFilters = {
            "-node_modules",
        },
        analyses = {
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            fieldalignment = true,
        },
        codelenses = {
            gc_details = true,
            test = true,
            tidy = true,
        },
    },
})
setup("graphql", {})
setup("html", {})
setup("jsonls", {
    schemas = require("schemastore").json.schemas(),
})
setup("lemminx", {}) -- XML
setup("pylsp", {})
setup("pyright", {})
setup("rust_analyzer", {})
setup("sqls", {})
setup("stylelint_lsp", {})

require("neodev").setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
                disable = { "lowercase-global" },
            },
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})
setup("sumneko_lua", {})
setup("taplo", {}) -- TOML
setup("terraformls", {})
setup("tflint", {})
setup("vimls", {})
setup("yamlls", { schemaStore = { enable = true } })

-- ====== typescript servers  ============================================================

local function open_deno_deps(e)
    local buf = e.buf
    local path = vim.b[buf].deno_deps_candidate
    if not path then
        return
    end
    if vim.fn.bufnr(path) >= 0 then
        -- in case of that deps.ts is opened already
        return
    end
    if not (vim.fn.filereadable(path)) then
        -- in case of that deps.ts does not exist
        return
    end

    -- open deps.ts in background (floatwin)
    require("backgroundfile").open(path)
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("open_deno_deps", {}),
    pattern = "typescript",
    callback = open_deno_deps,
    nested = true,
})

local function deno_root_dir(path)
    local marker = require("climbdir.marker")
    local found = require("climbdir").climb(path, marker.has_readable_file("deno.json"), {
        halt = marker.one_of(marker.has_readable_file("package.json"), marker.has_directory("node_modules")),
    })
    if found then
        vim.b[vim.fn.bufnr()].deno_deps_candidate = found .. "/deps.ts"
    end
    return found
end

local function node_root_dir(path)
    local marker = require("climbdir.marker")
    return require("climbdir").climb(
        path,
        marker.one_of(marker.has_readable_file("package.json"), marker.has_directory("node_modules")),
        {
            halt = marker.has_readable_file("deno.json"),
        }
    )
end

setup("denols", {
    init_options = {
        lint = true,
        unstable = true,
    },
    single_file_support = false,
    root_dir = deno_root_dir,
})
setup("tsserver", {
    settings = {
        typescript = {
            importModuleSpecifier = "relative",
        },
    },
    root_dir = node_root_dir,
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
})
require("mason-lspconfig").setup({ ensure_installed = lsp_list })
