-- Capabilities: this is usually needed for completion (cmp_nvim_lsp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- on_attach: what happens when a server attaches to a buffer
local on_attach = function(client, bufnr)
  -- example: enable keymaps
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  -- add any custom buffer-local setup here
end

-- on_init: optional hook that runs when the client starts
local on_init = function(client, _)
  -- Example: disable semantic tokens if you don’t like them
  client.server_capabilities.semanticTokensProvider = nil
end

-- Migrate from require("lspconfig") → vim.lsp.config / vim.lsp.enable

vim.lsp.config("rust_analyzer", {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "rust" },
  root_dir = vim.fs.root(0, { "Cargo.toml" }),
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
    },
  },
})
vim.lsp.enable("rust_analyzer")

vim.lsp.config("clangd", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "c", "cpp" },
})
vim.lsp.enable("clangd")

vim.lsp.config("ts_ls", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "javascript" },
})
vim.lsp.enable("ts_ls")

vim.lsp.config("html", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html" },
})
vim.lsp.enable("html")

vim.lsp.config("cssls", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "css" },
})
vim.lsp.enable("cssls")

vim.lsp.config("sqls", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "sql" },
})
vim.lsp.enable("sqls")

vim.lsp.config("texlab", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "tex" },
})
vim.lsp.enable("texlab")

vim.lsp.config("lua_ls", {  -- <- this is the correct server name
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "lua" },
  settings = {
    Lua = {
      runtime = {
        -- Tell the server which version of Lua you use (Neovim uses LuaJIT)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
vim.lsp.enable("lua_ls")
