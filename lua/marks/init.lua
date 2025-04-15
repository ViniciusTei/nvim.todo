local M = {}
local utils = require("utils")

function M.open()
  local marks = vim.fn.getmarklist()
  local global_marks = {}

  for _, mark in ipairs(marks) do
    local name = mark.mark:sub(2, 2)
    if name:match("[%u%d]") then
      local filepath = mark.file or ""
      local display = ""

      -- Check if is a project (look for a .git directory)
      local git_dir = vim.fn.finddir(".git", filepath .. ";")
      if git_dir ~= "" then
        local project_dir = vim.fn.fnamemodify(git_dir, ":h")
        local project_name = vim.fn.fnamemodify(project_dir, ":t")
        if project_name == "." then
          project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        end
        local filename = vim.fn.fnamemodify(filepath, ":t")
        display = string.format("%s -> %s:%s", name, project_name, filename)
      else
        display = string.format("%s -> %s", name, filepath)
      end

      table.insert(global_marks, display)
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
