local M = {}

local config = {
  todo_dir = "~/.todo",
  template = function()
    return "# TODO\n\n- [ ] Primeira tarefa\n"
  end,
  close_key = "<Esc>",
}

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
end

local function get_todo_file_path()
  local dir = vim.fn.expand(config.todo_dir)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  local path = dir .. "/todo.md"

  -- Cria template se não existir
  if vim.fn.filereadable(path) == 0 then
    local file = io.open(path, "w")
    if file then
      file:write(config.template())
      file:close()
    end
  end

  return path
end

local function open_centered_win(w, h)
  local width = math.floor(vim.o.columns * (w or 0.8))
  local height = math.floor(vim.o.lines * (h or 0.8))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  return {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  }
end

function M.open_todo()
  local filepath = get_todo_file_path()

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

  -- Carrega o conteúdo do arquivo
  vim.fn.jobstart({ "sh", "-c", "cat " .. filepath }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
      end
    end,
  })

  local win = vim.api.nvim_open_win(buf, true, open_centered_win())

  -- Mapeia salvar e fechar
  vim.keymap.set("n", config.close_key, function()
    -- salva
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local f = io.open(filepath, "w")
    for _, line in ipairs(lines) do
      f:write(line .. "\n")
    end
    f:close()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf })
end

return M
