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

-- NOTE: Compilação e execução para C / C++ e projetos (Debug e Release)
local function run_c_cpp(run, is_release)
  if vim.bo.modified then
    vim.cmd("silent! write")
  end

  local file_dir = vim.fn.expand("%:p:h")
  local file_name = vim.fn.expand("%:t")
  local file_root = vim.fn.expand("%:t:r")
  local ext = vim.fn.expand("%:e"):lower()

  local cmake_root = vim.fs.root(0, { "CMakeLists.txt" })
  local make_root = vim.fs.root(0, { "Makefile" })

  if (ext == "h" or ext == "hpp") and not cmake_root and not make_root then
    local src_c = file_dir .. "/" .. file_root .. ".c"
    local src_cpp = file_dir .. "/" .. file_root .. ".cpp"
    if (vim.uv or vim.loop).fs_stat(src_c) then
      ext = "c"
      file_name = file_root .. ".c"
    elseif (vim.uv or vim.loop).fs_stat(src_cpp) then
      ext = "cpp"
      file_name = file_root .. ".cpp"
    end
  end

  local cmd = nil
  local cwd = file_dir

  -- Flags de compilação recomendadas pelo LearnCpp:
  -- Debug:   -Wall -Wextra -g -O0 (símbolos de depuração, sem otimizações)
  -- Release: -Wall -Wextra -O3 -DNDEBUG (otimização máxima, remove asserts)
  local c_flags = is_release and "-Wall -Wextra -O3 -DNDEBUG" or "-Wall -Wextra -g -O0"
  local cpp_flags = (is_release and "-Wall -Wextra -O3 -DNDEBUG" or "-Wall -Wextra -g -O0")
    .. " -std=c++20 -D_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH"

  if ext == "c" then
    local exe = file_root .. ".exe"
    if run then
      cmd = string.format('clang %s "%s" -o "%s" && ".\\%s"', c_flags, file_name, exe, exe)
    else
      cmd = string.format('clang %s "%s" -o "%s"', c_flags, file_name, exe)
    end
  elseif ext == "cpp" or ext == "cc" or ext == "cxx" then
    local exe = file_root .. ".exe"
    if run then
      cmd = string.format('clang++ %s "%s" -o "%s" && ".\\%s"', cpp_flags, file_name, exe, exe)
    else
      cmd = string.format('clang++ %s "%s" -o "%s"', cpp_flags, file_name, exe)
    end
  elseif cmake_root then
    cwd = cmake_root
    local build_type = is_release and "Release" or "Debug"
    cmd = string.format("cmake -B build -DCMAKE_BUILD_TYPE=%s && cmake --build build --config %s", build_type, build_type)
  elseif make_root then
    cwd = make_root
    local make_cmd = (vim.fn.executable("make") == 1 and "make")
      or (vim.fn.executable("mingw32-make") == 1 and "mingw32-make")
      or (vim.fn.executable("nmake") == 1 and "nmake")
      or "make"
    cmd = make_cmd
  else
    vim.notify("Nenhum arquivo C/C++ ou configuração de build detectada.", vim.log.levels.WARN)
    return
  end

  if Snacks and Snacks.terminal then
    Snacks.terminal(cmd, {
      cwd = cwd,
      auto_close = false,
      start_insert = true,
    })
  else
    vim.cmd("botright split | resize 15 | terminal " .. cmd)
  end
end

-- === Configuração Debug (Padrão para desenvolvimento) ===
vim.keymap.set("n", "<leader>cx", function()
  run_c_cpp(true, false)
end, { desc = "Compilar e Executar [Debug] (C/C++/Projeto)" })

vim.keymap.set("n", "<leader>cb", function()
  run_c_cpp(false, false)
end, { desc = "Compilar / Build [Debug] (C/C++/Projeto)" })

vim.keymap.set("n", "<F5>", function()
  run_c_cpp(true, false)
end, { desc = "Compilar e Executar [Debug] (F5)" })

-- === Configuração Release (Otimizada / Produção) ===
vim.keymap.set("n", "<leader>cp", function()
  run_c_cpp(true, true)
end, { desc = "Compilar e Executar [Release/Otimizado] (C/C++)" })

vim.keymap.set("n", "<leader>cB", function()
  run_c_cpp(false, true)
end, { desc = "Compilar / Build [Release] (C/C++)" })

vim.keymap.set("n", "<C-F5>", function()
  run_c_cpp(true, true)
end, { desc = "Compilar e Executar [Release] (Ctrl+F5)" })

