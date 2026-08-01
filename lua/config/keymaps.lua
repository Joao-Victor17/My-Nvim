-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- NOTE: Keymap para selecionar tudo
vim.keymap.set("n", "<C-a>", function()
  vim.cmd.normal({ args = { "ggVG" }, bang = true })
end, { silent = true, desc = "Selecionar tudo" })

-- NOTE: Keymap para ter um comentário personalizado do JIRA
vim.keymap.set("n", "<leader>jo", function()
  local line = vim.api.nvim_get_current_line()
  local issue = line:match("([A-Z]+%-%d+)")
  if issue then
    vim.fn.jobstart({
      "xdg-open",
      "https://sotero-sos.atlassian.net/browse" .. issue,
    }, { detach = true })
  end
end)

-- NOTE: Keymap para realizar replace em todas as ocorrências em um arquivo
vim.keymap.set("n", "<leader>ra", ":%s/\\<<C-r><C-w>\\>/", { desc = "Substituir todas as ocorrências" })
