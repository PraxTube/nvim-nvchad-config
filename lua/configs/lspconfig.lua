require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 

vim.lsp.config("pyright", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python" },
})
vim.lsp.enable("pyright")

vim.lsp.config("marksman", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "markdown" },
})
vim.lsp.enable("marksman")

