require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "pyright", "clangd" }
})

local navic = require("nvim-navic")
navic.setup()

local on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "lua_ls", "pyright", "clangd" }

for _, server in ipairs(servers) do
    lspconfig[server].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
