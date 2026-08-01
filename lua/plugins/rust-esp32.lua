if true then
  return {}
end

return {
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              -- Força o Rust-Analyzer a entender a arquitetura do ESP32
              target = "xtensa-esp32-none-elf",
              buildScripts = { enable = true },
            },
            check = {
              -- Garante que as checagens em tempo real usem a arquitetura certa
              target = "xtensa-esp32-none-elf",
            },
          },
        },
      },
    },
  },
}
