local function trim_status(client)
  local config = {}
  for key, value in pairs(client["config"]) do
    if key == "_on_attach" then
      goto continue
    elseif type(value) == "function" then
      goto continue
    else
      config[key] = value
    end
    ::continue::
  end
  return {
    id = client["id"],
    config = config,
    messages = client["messages"],
    server_capabilities = client["server_capabilities"],
  }
end

-- LSPの設定を表示する
local function get_status(name)
  if name and name ~= "" then
    for _, client in pairs(vim.lsp.get_active_clients()) do
      if client["name"] == name then
        return trim_status(client)
      end
    end
    return nil
  end

  local stats = {}
  local selection = { "Select language server client: " }
  local names = {}
  for index, client in ipairs(vim.lsp.get_active_clients()) do
    stats[client["name"]] = trim_status(client)
    table.insert(selection, index .. ": " .. client["name"])
    table.insert(names, client["name"])
  end

  if #names == 0 then
    return nil
  elseif #names == 1 then
    name = names[1]
    return stats[name]
  else
    local num = vim.fn.inputlist(selection)
    name = names[num]
    return stats[name]
  end
end

local BUF_NAME = "[Lsp Status]"
local BUF_NAME_ESCAPED = "^\\[Lsp Status\\]$"

local function show_message(name, content)
  local buf = vim.fn.bufnr(BUF_NAME_ESCAPED, false)
  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, true)
    local group = vim.api.nvim_create_augroup('local-mod-lspstat', {clear = true})
    vim.api.nvim_create_autocmd('BufWinLeave', {
        buffer = buf,
        once = true,
        group = group,
        callback = function()
            vim.api.nvim_create_autocmd('CursorHold', {
                group = group,
                once = true,
                command = buf .. 'bwipeout!',
            })
        end,
    })
  end

  local count = vim.api.nvim_buf_line_count(buf)
  vim.api.nvim_buf_set_lines(buf, 0, count, false, vim.split(content, "\n"))
  vim.api.nvim_buf_set_name(buf, name)

  local winnr = vim.fn.bufwinnr(buf)
  if winnr == -1 then
    vim.cmd("belowright split")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
  else
    vim.fn.win_execute(winnr, ":edit!")
  end
end

local M = {}

--- Show status of a LSP
function M.show(name)
  local stat = get_status(name)
  if not stat then
    vim.api.nvim_err_write("any client is not found")
  else
    -- show_message(BUF_NAME, vim.fn.json_encode(stat))
    show_message(BUF_NAME, vim.inspect(stat, { depth = 10 }))
  end
end

--- Show statuses of all LSPs (include not activated)
function M.show_all()
  show_message(
    BUF_NAME,
    vim.inspect(
      vim.tbl_map(function(client)
        return get_status(client.name)
      end, vim.lsp.get_active_clients()),
      { depth = 10 }
    )
  )
end

return M
