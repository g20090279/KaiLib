require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "pyright", "clangd", "texlab" }
})

local navic = require("nvim-navic")
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

local function start_server(name, cmd, root_files)
    vim.lsp.start({
        name = name,
        cmd = cmd,
        root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
        on_attach = on_attach,
        capabilities = cmp_capabilities,
    })
end

local servers = {
    lua_ls = {
        cmd = { "lua-language-server" },
        root_files = { ".git", "init.lua" },
    },
    pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        root_files = { ".git", "pyproject.toml", "setup.py" },
    },
    clangd = {
        cmd = { "clangd" },
        root_files = { ".git", "compile_commands.json" },
    },
    bashls = {
        cmd = { "bash-language-server", "start" },
        root_files = { ".git" },
    },
}

for name, config in pairs(servers) do
    start_server(name, config.cmd, config.root_files)
end

