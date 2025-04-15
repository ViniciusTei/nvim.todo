local M = {}

function M.create_float_window(lines, opts)
  local width = opts.width or math.floor(vim.o.columns * 0.6)
  local height = opts.height or math.min(#lines + 2, math.floor(vim.o.lines * 0.6))
  local row = opts.row or math.floor((vim.o.lines - height) / 2)
  local col = opts.col or math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", opts.modifiable or false)
  vim.api.nvim_buf_set_option(buf, "filetype", opts.filetype or "markdown")

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = opts.border or "rounded",
  })

  local close_key = opts.close_key or "<Esc>"
  vim.keymap.set("n", close_key, function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf })

  return buf, win
end

return M
