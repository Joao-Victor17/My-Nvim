return {
  {
    "mrcjkb/rustaceanvim",
    opts = function()
      local opts = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                buildScripts = { enable = true },
              },
              check = {
                command = "clippy",
              },
            },
          },
        },
      }

      return opts
    end,
  },
}
