return {
  "zbirenbaum/copilot.lua",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = false,
      keymap = {
        accept = "<C-l>", -- Ctrl + l para aceitar a sugestão inteira
        accept_word = "<C-w>", -- Ctrl + w para aceitar apenas a próxima palavra
        accept_line = "<C-j>", -- Ctrl + j para aceitar apenas a próxima linha
        next = "<C-n>", -- Ctrl + n para próxima sugestão
        prev = "<C-p>", -- Ctrl + p para sugestão anterior
        dismiss = "<C-e>", -- Ctrl + e para dispensar sugestão
      },
    },
    panel = {
      enabled = false,
    },
  },
  keys = {
    -- Solicitar sugestão sob demanda no modo insert com <C-s>
    {
      "<C-s>",
      function()
        local suggestion = require("copilot.suggestion")
        if not suggestion.is_visible() then
          suggestion.next()
        end
      end,
      mode = "i",
      desc = "Copilot: Solicitar sugestão",
    },
  },
}
