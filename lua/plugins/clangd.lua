return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                clangd = {
                    mason = false, -- Usa o LLVM/clangd já instalado no sistema (C:\LLVM\64bits\LLVM-18.1.8)
                    cmd = {
                        "C:/LLVM/64bits/LLVM-18.1.8/bin/clangd.exe",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=WebKit",
                    },
                },
            },
        },
    },
}
