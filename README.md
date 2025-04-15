# 📝 nvim-todo

Um plugin simples para Neovim escrito em Lua que abre uma janela flutuante com sua lista de tarefas em formato Markdown.

### ⚠️ Aviso

> Este plugin foi criado com fins educacionais.

Eu estou usando o `nvim-todo` como um projeto pessoal de aprendizado para entender melhor como funcionam os plugins para o Neovim.


## ✨ Funcionalidades

- Cria um arquivo de TODO
- Abre o conteúdo em uma janela flutuante, editável como um buffer normal
- Permite salvar e fechar com um atalho customizável

---

## 📦 Instalação com [lazy.nvim](https://github.com/folke/lazy.nvim)


Adicione ao seu arquivo de plugins:

```lua
{
  "viniciusXYZ/nvim-todo", -- substitua pelo seu GitHub
  config = function()
    require("todolist").setup({
      -- Diretório onde os arquivos TODO serão salvos
      todo_dir = "~/.todo",

      -- Tecla usada para salvar e fechar a janela (dentro do buffer)
      close_key = "<Esc>",

      -- Template do conteúdo inicial do arquivo TODO
      template = function()
        return "# TODO\n\n- [ ] Primeira tarefa\n"
      end,
    })
  end,
  keys = {
    { "<leader>td", function() require("todolist").open_todo() end, desc = "TODO List" },
  },
}
```
