return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      local codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb.exe"

      dap.adapters.codelldb = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
          detached = false,
        },
      }

      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file (codelldb)",
            program = function()
              local exe = vim.fn.expand("%:p:r") .. ".exe"
              if (vim.uv or vim.loop).fs_stat(exe) then
                return exe
              end
              return vim.fn.input("Caminho do executavel: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${fileDirname}",
            stopOnEntry = false,
          },
        }
      end
    end,
  },
}
