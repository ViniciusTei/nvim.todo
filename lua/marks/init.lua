local M = {}
local utils = require("utils")

function M.open()
  local marks = vim.fn.getmarklist()
  local global_marks = {}

  for _, mark in ipairs(marks) do
    local name = mark.mark:sub(2, 2)
    if name:match("%u") then -- apenas letras maiúsculas
      local pos = mark.pos
      local bufname = vim.api.nvim_buf_get_name(mark.bufnr or 0)
      table.insert(global_marks, string.format("%s -> %s:%d:%d", name, bufname, pos[2], pos[3]))
    end
  end

  if #global_marks == 0 then
    table.insert(global_marks, "Nenhuma global mark encontrada.")
  end

  utils.create_float_window(global_marks, {
    filetype = "markdown",
    close_key = "<Esc>",
    border = "rounded",
  })
end

return M
